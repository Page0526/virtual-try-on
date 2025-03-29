




# Add this class to track iterations
class IterationTracker:
    def __init__(self, max_iterations=3):
        self.iteration_count = 0
        self.max_iterations = max_iterations
    
    def increment(self):
        self.iteration_count += 1
    
    def reset(self):
        self.iteration_count = 0
    
    @property
    def is_last_iteration(self):
        return self.iteration_count >= self.max_iterations - 1
        
    @property
    def needs_forced_finish(self):
        return self.iteration_count >= self.max_iterations

