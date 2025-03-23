import React from 'react';
import { Stack } from 'expo-router';
import { FittingProvider } from './context/fitting-context';

export default function VirtualFittingLayout() {
  return (
    <FittingProvider>
      <Stack screenOptions={{ headerShown: false }}>
        <Stack.Screen
          name="screens/capture"
          initialParams={{ type: 'garment' }}
        />
        <Stack.Screen name="screens/confirm-photo" />
        <Stack.Screen name="screens/combine" />
        <Stack.Screen name="screens/result" />
        <Stack.Screen name="screens/suggestions" />
      </Stack>
    </FittingProvider>
  );
}