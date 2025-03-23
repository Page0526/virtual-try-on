import React, { useState } from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, SafeAreaView, Dimensions } from 'react-native';
import { Ionicons, FontAwesome } from '@expo/vector-icons';

const ProductDetailScreen = () => {
  const [selectedColor, setSelectedColor] = useState('white');
  const colors = [
    { name: 'black', code: '#000000' },
    { name: 'orange', code: '#FFA500' },
    { name: 'blue', code: '#0000FF' },
    { name: 'red', code: '#FF0000' }
  ];
  
  // Responsive calculation based on screen width
  const windowWidth = Dimensions.get('window').width;
  const windowHeight = Dimensions.get('window').height;
  const isSmallScreen = windowWidth < 380;
  const isMediumScreen = windowWidth >= 380 && windowWidth < 768;
  const isLargeScreen = windowWidth >= 768;
  
  return (
    <SafeAreaView className="flex-1 bg-gray-100">
      <ScrollView className="flex-1">
        {/* Product Image */}
        <View className="relative items-center justify-center bg-white px-4 py-0">
          {/* Header */}
          <View className="absolute top-0 left-0 right-0 flex-row justify-between items-center p-4 z-10">
            <TouchableOpacity className="p-2">
              <Ionicons name="arrow-back" size={24} color="white" />
            </TouchableOpacity>
            <TouchableOpacity className="p-2">
              <Ionicons name="heart-outline" size={24} color="white" />
            </TouchableOpacity>
          </View>
          <View className="relative">
            <Image 
              source={require('@/assets/images/background.png')} 
              style={{ width: windowWidth , height: windowHeight * 0.5}}
              className="resize-contain"
              defaultSource={require('@/assets/images/background.png')}
            />
            {/* Indicators now inside the image at the bottom */}
            <View className="absolute bottom-4 left-0 right-0 flex-row justify-center">
              <View className="h-2 w-2 rounded-full bg-gray-800 mx-1" />
              <View className="h-2 w-2 rounded-full bg-gray-400 mx-1" />
              <View className="h-2 w-2 rounded-full bg-gray-400 mx-1" />
            </View>
          </View>
        </View>
        {/* Product Details */}
        <View className="bg-white mt-2 p-4 rounded-t-3xl">
          <View className="flex-row justify-between items-center">
            <Text className={`font-bold ${isLargeScreen ? 'text-2xl' : 'text-xl'}`}>Nike Air Force</Text>
            <Text className="text-red-600 font-bold text-xl">$199.00</Text>
          </View>
          
          {/* Ratings */}
          <View className="flex-row items-center mt-1">
            <View className="flex-row">
              {[1, 2, 3, 4, 5].map((star, index) => (
                <FontAwesome 
                  key={index} 
                  name={index < 4 ? "star" : "star-half-empty"} 
                  size={16} 
                  color="#FFD700" 
                />
              ))}
            </View>
            <Text className="text-gray-500 ml-1">4.5 (15 Reviews)</Text>
          </View>
          
          {/* Description */}
          <View className="mt-4">
            <Text className="font-semibold text-lg">Details</Text>
            <Text className="text-gray-600 mt-1">
              Nike Dri-Fit is a polyester fabric designed to help you keep dry so you can more comfortably work harder, longer.
            </Text>
          </View>
          
          {/* Color Selection */}
          <View className="mt-4">
            <Text className="font-semibold text-lg">Color:</Text>
            <View className="flex-row mt-2">
              {colors.map((color, index) => (
                <TouchableOpacity 
                  key={index}
                  className={`mr-3 p-0.5 rounded-full ${selectedColor === color.name ? 'border-2 border-red-600' : ''}`}
                  onPress={() => setSelectedColor(color.name)}
                >
                  <View 
                    style={{ backgroundColor: color.code }}
                    className="w-8 h-8 rounded-full"
                  />
                </TouchableOpacity>
              ))}
            </View>
          </View>
          
          {/* Size Selection */}
          <View className="mt-4">
            <Text className="font-semibold text-lg">Size:</Text>
            <TouchableOpacity className="mt-2 border border-gray-300 rounded-lg p-3 flex-row justify-between items-center">
              <Text className="text-gray-400">CHOOSE SIZE</Text>
              <Ionicons name="chevron-forward" size={20} color="gray" />
            </TouchableOpacity>
          </View>
          
          {/* Buy Button */}
          <TouchableOpacity className={`mt-6 bg-red-600 rounded-lg items-center justify-center py-4 ${isLargeScreen ? 'mx-16' : isMediumScreen ? 'mx-8' : 'mx-0'}`}>
            <Text className="text-white font-bold text-lg">Buy Now</Text>
          </TouchableOpacity>
          <View className="mb-8" />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default ProductDetailScreen;