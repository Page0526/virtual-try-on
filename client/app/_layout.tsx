import { Slot } from 'expo-router';
import React from 'react';
import { View } from 'react-native';
import { styled } from 'nativewind';
import { usePathname } from 'expo-router';
import BottomNavigation from '../src/components/BottomNavigation';
import { CartProvider } from '@/src/cartContext';
import { SafeAreaProvider } from 'react-native-safe-area-context';

const StyledView = styled(View);

export default function RootLayout() {
  const pathname = usePathname();
  
  // Paths where we don't want to show the bottom navigation
  const noBottomNavPaths = ['/', '/login', '/register', '/onboarding', '/landing_page', '/shop/product_details', '/shop/cart'];
  
  // Check if we should show bottom navigation
  const showBottomNav = !noBottomNavPaths.includes(pathname);

  // Debug
  console.log('Current pathname:', pathname);
  console.log('Showing bottom nav:', showBottomNav);

  return (
    <SafeAreaProvider>
      <CartProvider>
        <StyledView className="flex-1">
          <Slot />
          {showBottomNav && <BottomNavigation />}
        </StyledView>
      </CartProvider>
    </SafeAreaProvider>
  );
}