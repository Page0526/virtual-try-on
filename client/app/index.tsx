import { SafeAreaProvider } from 'react-native-safe-area-context';
import {Text, View} from 'react-native';
import LandingScreen from './landing_page';
import { Redirect } from 'expo-router';

export default function App() {
  return <Redirect href='/landing_page'/>
}