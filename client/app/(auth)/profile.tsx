import React from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, SafeAreaView, useWindowDimensions } from 'react-native';
import { Ionicons, MaterialIcons, FontAwesome } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

export default function ProfileScreen() {
  const { width } = useWindowDimensions();
  const isTablet = width >= 768;
  const router = useRouter();
  
  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1">
        <View className="px-4 pt-5 pb-6">
          <TouchableOpacity onPress={() => router.replace('/(tabs)/shop/home')} className="absolute top-5 left-5">
            <Ionicons name="arrow-back" size={24} color="black" />
          </TouchableOpacity>
          <View className={`items-center ${isTablet ? 'mt-8' : 'mt-2'}`}>
            <View className="bg-white rounded-full p-5 shadow-sm">
              <View className="w-20 h-20 bg-gray-200 rounded-full items-center justify-center">
                {React.useState(false)[0] ? (
                  <View className="w-16 h-16 items-center justify-center">
                    <FontAwesome name="user" size={40} color="#555" />
                  </View>
                ) : (
                  <Image 
                    source={require('@/assets/images/avatar.jpg')} 
                    className="w-16 h-16"
                    onError={() => React.useState(false)[1](true)}
                  />
                )}
              </View>
            </View>
            
            <Text className={`font-bold mt-4 ${isTablet ? 'text-2xl' : 'text-xl'}`}>Welcome</Text>
            <Text className={`text-gray-500 mt-1 ${isTablet ? 'text-base' : 'text-sm'}`}>Sign in to take full advantage of the app</Text>
            
            <TouchableOpacity
              className={`mt-6 w-full bg-red-500 rounded-full py-3 items-center justify-center ${
                isTablet ? 'max-w-md' : 'max-w-full'
              }`}
            >
              <Text className="text-white font-semibold text-lg">Sign In</Text>
            </TouchableOpacity>
          </View>
          
          <View className={`bg-white rounded-lg mx-4 ${isTablet ? 'max-w-md self-center w-full' : ''}`}>
            <MenuItem icon="briefcase" label="About Us" />
            <MenuItem icon="refresh" label="Returns" />
            <MenuItem icon="cube" label="Delivery" />
            <MenuItem icon="credit-card" label="Payment" />
            <MenuItem icon="book" label="Contacts" isLast={true} />
          </View>
          
          <View className={`mt-4 bg-blue-500 mx-4 rounded-lg overflow-hidden ${isTablet ? 'max-w-md self-center w-full' : ''}`}>
            <MenuItem 
              icon="cog" 
              label="Settings" 
              isLast={true} 
              iconColor="white" 
              textColor="white"
            />
          </View>
          
          {isTablet && <View className="h-16" />}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

function MenuItem({ 
  icon, 
  label, 
  isLast = false, 
  iconColor = "#4F7DF3", 
  textColor = "#333"
}: { 
  icon: string; 
  label: string; 
  isLast?: boolean; 
  iconColor?: string;
  textColor?: string;
}) {
  
  const iconComponents: {[key: string]: JSX.Element} = {
    'briefcase': <Ionicons name="briefcase-outline" size={22} color={iconColor} />,
    'refresh': <Ionicons name="refresh-outline" size={22} color={iconColor} />,
    'cube': <Ionicons name="cube-outline" size={22} color={iconColor} />,
    'credit-card': <Ionicons name="card-outline" size={22} color={iconColor} />,
    'book': <Ionicons name="book-outline" size={22} color={iconColor} />,
    'cog': <Ionicons name="settings-outline" size={22} color={iconColor} />
  };
  
  return (
    <TouchableOpacity className={`flex-row items-center py-4 px-4 ${!isLast ? 'border-b border-gray-100' : ''}`}>
      <View className="w-8 h-8 items-center justify-center">
        {iconComponents[icon]}
      </View>
      <Text className={`ml-3 flex-1 text-base`} style={{ color: textColor }}>{label}</Text>
      <MaterialIcons name="keyboard-arrow-right" size={24} color={textColor === "white" ? "white" : "#CCCCCC"} />
    </TouchableOpacity>
  );
}