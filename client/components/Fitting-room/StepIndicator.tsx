import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useColorScheme } from '@/hooks/useColorScheme';

interface StepIndicatorProps {
  currentStep: number;
  totalSteps: number;
  stepLabels: string[];
}

const StepIndicator: React.FC<StepIndicatorProps> = ({ currentStep, totalSteps, stepLabels }) => {
  const colorScheme = useColorScheme();

  return (
    <View style={styles.container}>
      <Text style={[styles.text, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
        Bước {currentStep}/{totalSteps}: {stepLabels[currentStep - 1]}
      </Text>
      <View style={styles.stepContainer}>
        {Array.from({ length: totalSteps }).map((_, index) => (
          <View
            key={index}
            style={[
              styles.step,
              {
                backgroundColor:
                  index < currentStep
                    ? '#007AFF'
                    : colorScheme === 'dark'
                    ? '#444'
                    : '#e0e0e0',
              },
            ]}
          />
        ))}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 20,
  },
  text: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 10,
  },
  stepContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
  },
  step: {
    width: 30,
    height: 8,
    borderRadius: 4,
    marginHorizontal: 5,
  },
});

export default StepIndicator;