import React from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { useColorScheme } from '@/hooks/useColorScheme';

interface StepIndicatorProps {
  currentStep: number;
  totalSteps: number;
  stepLabels: string[];
  activeColor?: string;
  onStepPress?: (step: number) => void;
}

const StepIndicator: React.FC<StepIndicatorProps> = ({ 
  currentStep, 
  totalSteps, 
  stepLabels, 
  activeColor = '#007AFF',
  onStepPress 
}) => {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  
  const textColor = isDark ? '#FFFFFF' : '#333333';
  const inactiveColor = isDark ? '#444444' : '#E0E0E0';
  
  return (
    <View style={styles.container}>
      <Text style={[styles.stepText, { color: textColor }]}>
        Step {currentStep}/{totalSteps}
      </Text>
      
      <Text style={[styles.stepLabel, { color: activeColor }]}>
        {stepLabels[currentStep - 1]}
      </Text>
      
      <View style={styles.stepContainer}>
        {stepLabels.map((label, index) => {
          const stepNumber = index + 1;
          const isActive = stepNumber <= currentStep;
          const isCurrentStep = stepNumber === currentStep;
          
          return (
            <Pressable
              key={index}
              onPress={() => onStepPress && onStepPress(stepNumber)}
              style={styles.stepWrapper}
              disabled={!onStepPress}
            >
              <View style={styles.stepItemContainer}>
                <View
                  style={[
                    styles.step,
                    {
                      backgroundColor: isActive ? activeColor : inactiveColor,
                      width: isCurrentStep ? 40 : 30,
                    },
                  ]}
                />
                <Text 
                  style={[
                    styles.stepItemLabel,
                    { 
                      color: isActive ? activeColor : isDark ? '#999999' : '#999999',
                      fontWeight: isCurrentStep ? '600' : '400',
                      opacity: isActive ? 1 : 0.7
                    }
                  ]}
                  numberOfLines={1}
                >
                  {label}
                </Text>
              </View>
            </Pressable>
          );
        })}
      </View>
    </View>
  );
};


const styles = StyleSheet.create({
  container: {
    marginVertical: 16,
    paddingHorizontal: 12
  },
  stepText: {
    fontSize: 14,
    textAlign: 'center',
    marginBottom: 4,
    fontWeight: '500',
  },
  stepLabel: {
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: 16,
  },
  stepContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  stepWrapper: {
    flex: 1,
  },
  stepItemContainer: {
    alignItems: 'center',
  },
  step: {
    height: 8,
    borderRadius: 4,
    marginHorizontal: 2,
    marginBottom: 8,
  },
  stepItemLabel: {
    fontSize: 12,
    textAlign: 'center',
    paddingHorizontal: 2,
  }
});

export default StepIndicator;