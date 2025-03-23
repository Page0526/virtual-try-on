import React from 'react';
import { Stack } from 'expo-router';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { CartProvider } from '@/app/(tabs)/cart/cartContext';

export default function Layout() {
  return (
    <SafeAreaProvider>
      <CartProvider>
        <Stack />
      </CartProvider>
    </SafeAreaProvider>
)};