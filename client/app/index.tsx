import { SafeAreaProvider } from 'react-native-safe-area-context';
import {Text, View} from 'react-native';

export default function App() {
  return (
    <View className = "flex-1 justify-center items-center bg-white">
      <Text> Hello, world!</Text>
    </View>
  );
}