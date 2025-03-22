import { SafeAreaProvider } from 'react-native-safe-area-context';
import {Text, View} from 'react-native';
import LandingScreen from './landing_page';
import React from 'react';



export default function App() {
  return (
    <SafeAreaProvider>
      <LandingScreen />
    </SafeAreaProvider>
  );
}