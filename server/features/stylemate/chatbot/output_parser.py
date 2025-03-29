from langchain_core.pydantic_v1 import BaseModel, Field, validator
from typing import Optional,  Union
from langchain.agents.output_parsers import ReActJsonSingleInputOutputParser
from langchain_core.agents import AgentAction, AgentFinish

import json
import re



class ReActResponse(BaseModel):
    thought: str = Field(..., description="Current thought of the agent")
    action: Optional[str] = Field(None, description="Tool to use, if necessary")
    action_input: Optional[Union[str, dict]] = Field(None, description="Input data for the tool")
    final_answer: Optional[str] = Field(None, description="Final answer if a result is available")
    
    @classmethod
    def parse_json(cls, json_str: str) -> "ReActResponse":
        """Parse a JSON string into a ReActResponse object"""
        # Extract JSON content between ```json and ``` if present
        json_match = re.search(r'```json\s*(.*?)\s*```', json_str, re.DOTALL)
        if json_match:
            json_content = json_match.group(1)
        else:
            json_content = json_str
            
        # Add enclosing braces if they're missing
        json_content = json_content.strip()
        if not json_content.startswith('{'):
            json_content = '{' + json_content + '}'
            
        # Fix potential JSON formatting issues
        json_content = json_content.replace('\n', ' ')
        
        try:
            # Parse the JSON content
            data = json.loads(json_content)
            return cls(**data)
        except json.JSONDecodeError as e:
            raise ValueError(f"Invalid JSON format: {e}. Content: {json_content}")

    @validator("action", "action_input", "final_answer")
    def check_action_or_answer(cls, v, values, **kwargs):
        # Make sure we have either action+action_input or final_answer
        if "thought" in values:
            has_action = values.get("action") is not None
            has_action_input = values.get("action_input") is not None
            has_final_answer = values.get("final_answer") is not None
            
            if has_final_answer and (has_action or has_action_input):
                raise ValueError("Cannot have both action and final_answer")
            if not has_final_answer and not (has_action and has_action_input):
                if v is None and kwargs.get("field").name == "final_answer":
                    raise ValueError("Need action and action_input or final_answer")
        return v


class CustomOutputParser(ReActJsonSingleInputOutputParser):
    """Parser that uses structured output to process LLM results."""
    
    def parse(self, text: str) -> Union[AgentAction, AgentFinish]:
        """Parse output from LLM."""

        if "ITERATION_LIMIT_APPROACHING" in text:
            # Force a final answer when we're at the iteration limit
            last_thought = text.split("ITERATION_LIMIT_APPROACHING")[1].strip()
            return AgentFinish(
                return_values={"output": f"Based on my analysis so far: {last_thought}"},
                log=f"Reached iteration limit. Final answer: {last_thought}"
            )

            # If that fails, try with structured output
        try:
            structured_response = ReActResponse.parse_json(text)
            print("Structured response:", structured_response)
            if structured_response.final_answer is not None:
                return AgentFinish(
                    return_values={"output": structured_response.final_answer},
                    log=structured_response.thought
                )
            elif structured_response.action is not None:
                # This is an action
                return AgentAction(
                    tool=structured_response.action,
                    tool_input=structured_response.action_input or "",
                    log=structured_response.thought
                )
            else:
                # Not enough information, return error
                return AgentFinish(
                        return_values={"output": f"Based on my analysis: {structured_response.thought}"},
                        log=f"No action or final_answer found. Finishing with thought: {structured_response.thought}"
                    )
                
        except Exception as e:
            # If both methods fail, handle as a regular response
            return AgentFinish(
                    return_values={"output": f"After analyzing your question, {text[:200]}..."},
                    log=f"Parser error: {str(e)}"
                )