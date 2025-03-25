import React, { useState } from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, SafeAreaView, Dimensions, Alert } from 'react-native';
import { Ionicons, FontAwesome } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { useRouter } from 'expo-router';
import { useCart } from '../cart/cartContext';

const ProductDetailScreen = () => {
  const router = useRouter();
  const { addToCart } = useCart();
  const [selectedColor, setSelectedColor] = useState('white');
  const [selectedSize, setSelectedSize] = useState('');
  
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
  
  const handleAddToCart = () => {
    // Create a new cart item with product details
    const newItem = {
      id: Date.now(), // Using timestamp as unique ID
      name: 'Maxi Summer Dress',
      price: 270.99,
      quantity: 1,
      itemlink: 'https://harpersbazaarprod.vtexassets.com/unsafe/768x0/center/middle/filters:quality(80)/https%3A%2F%2Fharpersbazaarprod.vtexassets.com%2Farquivos%2Fids%2F717646%2Fimage_1.jpg%3Fv%3D638720661038070000'
    };
    
    // Add the item to cart using our context
    addToCart(newItem);
    
    // Show success message
    Alert.alert(
      "Added to Cart",
      "Item has been added to your cart",
      [
        { 
          text: "Continue Shopping", 
          style: "cancel" 
        },
        { 
          text: "Go to Cart", 
          onPress: () => router.push('/(tabs)/cart/cart')
        }
      ]
    );
  };
  
  return (
    <SafeAreaView className="flex-1 bg-gray-100">
      <ScrollView className="flex-1" contentContainerStyle={{ paddingBottom: 80 }}>
        {/* Product Image */}
        <View className="relative items-center justify-center bg-white px-4 py-0">
          {/* Header */}
          <View className="absolute top-3 left-0 right-0 flex-row justify-between items-center p-4 z-10">

            <TouchableOpacity 
              className="p-2" 
              onPress={() => router.push('/(tabs)/shop/home')}>
              <Ionicons name="arrow-back" size={24} color="#e14e69" />
            </TouchableOpacity>

            <TouchableOpacity className="p-2">
              <Ionicons name="heart-outline" size={24} color="#e14e69" />
            </TouchableOpacity>
          </View>
          <View className="relative">
            <Image 
              source={require('@/assets/images/dress.jpg')} 
              style={{ width: windowWidth , height: windowHeight * 0.5}}
              className="resize-contain"
              defaultSource={require('@/assets/images/dress.jpg')}
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
            <Text className={`font-bold ${isLargeScreen ? 'text-2xl' : 'text-xl'}`}>Maxi Summer Dress</Text>
            <Text style={{color: Colors.PRIMARY}} className="font-bold text-xl">$270.99</Text>
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
            A signature midi style, our best-selling Josephina Dress is back this Spring with the same effortless day-to-night sensibility in a new bluebird colorway. Featuring a fitted knit bodice and a lightweight tiered cotton skirt, Josephina is a universally flattering silhouette for ease of wear. Style the Josephina Dress back to your favorite pair of sandals or flats for an elevated daytime look, or with a strappy heel for an evening out. Product Details: • Midi length • Sweetheart neckline • Sleeveless • Unlined
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
          <View className="mt-4 mb-8">
            <Text className="font-semibold text-lg">Size:</Text>
            <TouchableOpacity className="mt-2 border border-gray-300 rounded-[20px] p-3 flex-row justify-between items-center">
              <Text className="text-gray-400">CHOOSE SIZE</Text>
              <Ionicons name="chevron-forward" size={20} color="gray" />
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
      
      {/* Fixed Footer with Add to Cart Button */}
      <View className="absolute bottom-0 left-0 right-0 bg-white px-4 py-3 shadow-lg border-t border-gray-200">
        <TouchableOpacity 
          style={{backgroundColor: Colors.PRIMARY}} 
          className="rounded-[20px] items-center justify-center py-4"
          onPress={handleAddToCart}
        >
          <Text className="text-white font-bold text-lg">Add to Cart</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

export default ProductDetailScreen;