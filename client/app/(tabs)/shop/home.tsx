import React, { useState, useRef, useEffect } from 'react';
import { View, Text, Image, ScrollView, TextInput, TouchableOpacity, SafeAreaView, Platform, StatusBar, Dimensions, Animated, FlatList } from 'react-native';
import { Feather, Ionicons, AntDesign, MaterialIcons, FontAwesome } from '@expo/vector-icons';
import { styled } from 'nativewind';

// Styled components for NativeWind v2
const StyledView = styled(View);
const StyledText = styled(Text);
const StyledImage = styled(Image);
const StyledScrollView = styled(ScrollView);
const StyledTextInput = styled(TextInput);
const StyledTouchableOpacity = styled(TouchableOpacity);
const StyledSafeAreaView = styled(SafeAreaView);

// Get screen dimensions for responsive sizing
const { width: screenWidth } = Dimensions.get('window');

export default function HomeScreen() {
  // Sample data with multiple images for slideshow
  const recentOutfits = [
    {
      id: '1',
      image: require('@/assets/images/background.png'),
      isMostOrdered: true,
    },
    {
      id: '2',
      image: require('@/assets/images/outfit1.jpg'), // Replace with different image
      isMostOrdered: false,
    },
    {
      id: '3',
      image: require('@/assets/images/background.png'), // Replace with different image
      isMostOrdered: false,
    },
  ];

  // Sample product data
  const products = [
    {
      id: '1',
      name: 'Floral Summer Dress',
      price: 59.99,
      image: require('@/assets/images/background.png'),
      category: 'Dress'
    },
    {
      id: '2',
      name: 'Slim Fit Jeans',
      price: 49.99,
      image: require('@/assets/images/outfit1.jpg'),
      category: 'Jeans'
    },
    {
      id: '3',
      name: 'Casual T-shirt',
      price: 24.99,
      image: require('@/assets/images/background.png'),
      category: 'T-s'
    },
    {
      id: '4',
      name: 'Pleated Midi Skirt',
      price: 39.99,
      image: require('@/assets/images/background.png'),
      category: 'Skirts'
    },
    {
      id: '5',
      name: 'Denim Jacket',
      price: 69.99,
      image: require('@/assets/images/outfit1.jpg'),
      category: 'Jeans'
    },
    {
      id: '6',
      name: 'Maxi Summer Dress',
      price: 79.99,
      image: require('@/assets/images/background.png'),
      category: 'Dress'
    },
  ];

  // State for slideshow
  const [currentIndex, setCurrentIndex] = useState(0);
  const [previousIndex, setPreviousIndex] = useState(0);
  const [isAnimating, setIsAnimating] = useState(false);
  
  // Animation values - using two values for simultaneous animation
  const currentSlideAnimation = useRef(new Animated.Value(0)).current;
  const nextSlideAnimation = useRef(new Animated.Value(screenWidth)).current;
  
  // Card size constants
  const CARD_WIDTH = screenWidth * 0.8;
  const CARD_HEIGHT = screenWidth * 0.9;

  // Preload all images
  useEffect(() => {
    // Prefetch or cache images if needed
    recentOutfits.forEach(outfit => {
      // For local images, no prefetching needed in React Native
      // But we could add additional logic here for remote images
    });
  }, []);
  
  // Navigation functions with improved animation
  const goToNextSlide = () => {
    if (isAnimating) return; // Prevent animation interruption
    
    const newIndex = currentIndex < recentOutfits.length - 1 ? currentIndex + 1 : 0;
    animateToSlide(newIndex, 'right');
  };

  const goToPrevSlide = () => {
    if (isAnimating) return; // Prevent animation interruption
    
    const newIndex = currentIndex > 0 ? currentIndex - 1 : recentOutfits.length - 1;
    animateToSlide(newIndex, 'left');
  };

  // Improved animation function with single-step transition
  const animateToSlide = (newIndex: React.SetStateAction<number>, direction: string) => {
    if (isAnimating || newIndex === currentIndex) return;
    
    setIsAnimating(true);
    setPreviousIndex(currentIndex);
    
    // Set initial positions based on direction
    const currentInitial = 0;
    const nextInitial = direction === 'right' ? CARD_WIDTH : -CARD_WIDTH;
    
    // Set final positions based on direction
    const currentFinal = direction === 'right' ? -CARD_WIDTH : CARD_WIDTH;
    const nextFinal = 0;
    
    // Reset animation values
    currentSlideAnimation.setValue(currentInitial);
    nextSlideAnimation.setValue(nextInitial);
    
    // Update state before animation
    setCurrentIndex(newIndex);
    
    // Run simultaneous animations for smooth transition
    Animated.parallel([
      // Current slide animation
      Animated.spring(currentSlideAnimation, {
        toValue: currentFinal,
        friction: 8,
        tension: 40,
        useNativeDriver: true,
      }),
      // Next slide animation
      Animated.spring(nextSlideAnimation, {
        toValue: nextFinal,
        friction: 8,
        tension: 40,
        useNativeDriver: true,
      })
    ]).start(() => {
      // Animation complete
      setIsAnimating(false);
    });
  };

  // State for categories
  const [selectedCategory, setSelectedCategory] = useState('All');
  
  const categories = [
    { id: '1', name: 'All', isActive: true },
    { id: '2', name: 'Skirts', isActive: false },
    { id: '3', name: 'Jeans', isActive: false },
    { id: '4', name: 'Dress', isActive: false },
    { id: '5', name: 'T-s', isActive: false },
  ];

  // Filter products by selected category
  const filteredProducts = selectedCategory === 'All' 
    ? products 
    : products.filter(product => product.category === selectedCategory);

  // Handle category selection
  const handleCategoryPress = (categoryName: React.SetStateAction<string>) => {
    setSelectedCategory(categoryName);
  };

  // Sample news data
  const [newsItems, setNewsItems] = useState([
    {
      id: '1',
      title: 'Summer Fashion Trends: What to Wear This Season',
      image: require('@/assets/images/background.png'),
      source: 'Fashion Magazine',
      time: '2 hours ago',
      liked: false,
    },
    {
      id: '2',
      title: 'Sustainable Fashion: How Brands Are Going Green in 2023',
      image: require('@/assets/images/outfit1.jpg'),
      source: 'Eco Style',
      time: '1 day ago',
      liked: true,
    },
    {
      id: '3',
      title: 'Celebrity Style Spotlight: Red Carpet Looks That Turned Heads',
      image: require('@/assets/images/background.png'),
      source: 'Fashion Weekly',
      time: '3 days ago',
      liked: false,
    },
    {
      id: '4',
      title: 'Fashion Tech: How AR and VR Are Changing How We Shop for Clothes',
      image: require('@/assets/images/outfit1.jpg'),
      source: 'Tech Fashion',
      time: '1 week ago',
      liked: false,
    },
  ]);

  // Toggle like status for news items
  const toggleLike = (newsId: string) => {
    setNewsItems(prevItems => 
      prevItems.map(item => 
        item.id === newsId ? {...item, liked: !item.liked} : item
      )
    );
  };

  return (
    <StyledSafeAreaView className={`flex-1 bg-white ${Platform.OS === 'android' ? 'pt-8' : ''}`}>
      <StatusBar barStyle="dark-content" />
      
      {/* Header - Modified to have welcome text on one line */}
      <StyledView className="px-4 pt-2 flex-row items-center justify-between">
        <StyledText className="text-base">
          <StyledText className="font-medium">Welcome back, </StyledText>
          <StyledText className="font-bold text-red-500">Tuoc Nguyen</StyledText>
        </StyledText>
        <StyledImage 
          source={require('@/assets/images/react-logo.png')}
          className="w-10 h-10 rounded-full"
        />
      </StyledView>

      {/* Search Bar */}
      <StyledView className="mt-4 mx-4 flex-row items-center bg-gray-100 rounded-full px-4 py-2">
        <Feather name="search" size={20} color="gray" />
        <StyledTextInput
          className="flex-1 ml-2 text-base"
          placeholder="Search"
          placeholderTextColor="gray"
        />
        <Ionicons name="mic-outline" size={20} color="gray" />
      </StyledView>

      <StyledScrollView className="flex-1 mt-4" showsVerticalScrollIndicator={false}>
        {/* Recent Outfits Section - with improved slideshow */}
        <StyledView className="px-2">
          <StyledText className="text-lg font-bold mb-3 px-2">Recent outfits</StyledText>
          
          {/* Carousel Container with Navigation Buttons */}
          <StyledView className="h-auto mb-2 items-center">
            <StyledView className="relative" style={{ height: CARD_HEIGHT + 20, width: CARD_WIDTH }}>
              {/* Navigation Button - Previous */}
              <StyledTouchableOpacity 
                className="absolute left-0 top-1/2 -translate-y-1/2 z-20 bg-white/80 rounded-full p-2 shadow-md" 
                style={{ left: -15 }}
                onPress={goToPrevSlide}
                activeOpacity={0.7}
                disabled={isAnimating}
              >
                <AntDesign name="left" size={20} color="#FF4757" />
              </StyledTouchableOpacity>
              
              {/* Animation Container for Slides */}
              <StyledView style={{ overflow: 'hidden', width: CARD_WIDTH, height: CARD_HEIGHT, position: 'relative' }}>
                {/* Previous/Current Slide */}
                <Animated.View 
                  style={{
                    transform: [{ translateX: currentSlideAnimation }],
                    position: 'absolute',
                    width: CARD_WIDTH,
                    height: CARD_HEIGHT,
                    zIndex: 1,
                    shadowColor: "#000",
                    shadowOffset: { width: 0, height: 2 },
                    shadowOpacity: 0.3,
                    shadowRadius: 10,
                    elevation: 5,
                  }}
                >
                  <StyledImage
                    source={recentOutfits[previousIndex].image}
                    className="rounded-[30px] w-full h-full"
                    resizeMode="cover"
                  />
                  
                  {/* Most Ordered Tag */}
                  {recentOutfits[previousIndex].isMostOrdered && (
                    <StyledView className="absolute bottom-6 left-6">
                      <StyledView className="bg-white px-4 py-2 rounded-full shadow-md">
                        <StyledText className="font-bold">Most ordered 🔥</StyledText>
                      </StyledView>
                    </StyledView>
                  )}
                </Animated.View>
                
                {/* Next/Current Slide */}
                <Animated.View 
                  style={{
                    transform: [{ translateX: nextSlideAnimation }],
                    position: 'absolute',
                    width: CARD_WIDTH,
                    height: CARD_HEIGHT,
                    zIndex: isAnimating ? 2 : 1,
                    shadowColor: "#000",
                    shadowOffset: { width: 0, height: 2 },
                    shadowOpacity: 0.3,
                    shadowRadius: 10,
                    elevation: 5,
                  }}
                >
                  <StyledImage
                    source={recentOutfits[currentIndex].image}
                    className="rounded-[30px] w-full h-full"
                    resizeMode="cover"
                  />
                  
                  {/* Most Ordered Tag */}
                  {recentOutfits[currentIndex].isMostOrdered && (
                    <StyledView className="absolute bottom-6 left-6">
                      <StyledView className="bg-white px-4 py-2 rounded-full shadow-md">
                        <StyledText className="font-bold">Most ordered 🔥</StyledText>
                      </StyledView>
                    </StyledView>
                  )}
                </Animated.View>
              </StyledView>
              
              {/* Navigation Button - Next */}
              <StyledTouchableOpacity 
                className="absolute right-0 top-1/2 -translate-y-1/2 z-20 bg-white/80 rounded-full p-2 shadow-md" 
                style={{ right: -15 }}
                onPress={goToNextSlide}
                activeOpacity={0.7}
                disabled={isAnimating}
              >
                <AntDesign name="right" size={20} color="#FF4757" />
              </StyledTouchableOpacity>
            </StyledView>
            
            {/* Navigation Indicators */}
            <StyledView className="flex-row justify-center items-center mt-4 space-x-2">
              {recentOutfits.map((_, index) => (
                <TouchableOpacity 
                  key={index} 
                  onPress={() => {
                    if (isAnimating || index === currentIndex) return;
                    // Determine direction based on current index
                    const direction = index > currentIndex ? 'right' : 'left';
                    animateToSlide(index, direction);
                  }}
                  activeOpacity={0.7}
                  disabled={isAnimating}
                >
                  <StyledView 
                    className={`h-2.5 w-2.5 rounded-full ${currentIndex === index ? 'bg-red-500' : 'bg-gray-300'}`}
                  />
                </TouchableOpacity>
              ))}
            </StyledView>
          </StyledView>
        </StyledView>


        {/* Products Grid */}
        <StyledView className="px-4 mt-4">
          <StyledText className="text-lg font-bold mb-4">Products</StyledText>

           {/* Categories */}
        <StyledScrollView 
          horizontal 
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={{ paddingHorizontal: 8, paddingVertical: 16 }}
        >
          {categories.map((category) => (
            <StyledTouchableOpacity
              key={category.id}
              className={`mx-2 px-4 py-2 rounded-full ${selectedCategory === category.name ? 'bg-red-500' : 'bg-gray-200'}`}
              onPress={() => handleCategoryPress(category.name)}
            >
              <StyledText className={`font-medium ${selectedCategory === category.name ? 'text-white' : 'text-gray-800'}`}>
                {category.name}
              </StyledText>
            </StyledTouchableOpacity>
          ))}
        </StyledScrollView>
          
          <StyledView className="flex-row flex-wrap justify-between">
            {filteredProducts.map((product) => (
              <StyledView 
                key={product.id} 
                className="bg-white rounded-xl shadow-md mb-4 w-[48%]"
              >
                {/* Product Image */}
                <StyledImage 
                  source={product.image}
                  className="w-full h-32 rounded-t-xl"
                  resizeMode="cover"
                />
                
                {/* Product Info */}
                <StyledView className="p-3">
                  <StyledText className="font-medium text-sm" numberOfLines={1}>
                    {product.name}
                  </StyledText>
                  
                  <StyledView className="flex-row justify-between items-center mt-2">
                    <StyledText className="font-bold text-base">
                      ${product.price}
                    </StyledText>
                    
                    <StyledTouchableOpacity className="bg-red-500 rounded-full p-1.5">
                      <Feather name="shopping-bag" size={14} color="white" />
                    </StyledTouchableOpacity>
                  </StyledView>
                </StyledView>
              </StyledView>
            ))}
          </StyledView>
          
          {/* Empty state when no products */}
          {filteredProducts.length === 0 && (
            <StyledView className="items-center justify-center py-10">
              <MaterialIcons name="search-off" size={48} color="#CCCCCC" />
              <StyledText className="text-gray-400 mt-2 text-center">
                No products found in this category
              </StyledText>
            </StyledView>
          )}
        </StyledView>

        {/* Fashion News Section */}
        <StyledView className="px-4 mt-8">
          <StyledText className="text-lg font-bold mb-4">Fashion News</StyledText>
          
          {/* News Grid - Single Column */}
          <StyledView className="space-y-4">
            {newsItems.map((news) => (
              <StyledView 
                key={news.id} 
                className="bg-white rounded-xl shadow-md overflow-hidden"
              >
                {/* News Image */}
                <StyledImage 
                  source={news.image}
                  className="w-full h-48"
                  resizeMode="cover"
                />
                
                {/* News Content */}
                <StyledView className="p-4">
                  {/* Title */}
                  <StyledText className="font-bold text-base" numberOfLines={2}>
                    {news.title}
                  </StyledText>
                  
                  {/* Publication Info and Like Button */}
                  <StyledView className="flex-row justify-between items-center mt-3">
                    <StyledView>
                      <StyledText className="text-gray-500 text-xs">
                        {news.source}
                      </StyledText>
                      <StyledText className="text-gray-400 text-xs mt-1">
                        {news.time}
                      </StyledText>
                    </StyledView>
                    
                    {/* Like Button */}
                    <StyledTouchableOpacity 
                      className="p-2" 
                      onPress={() => toggleLike(news.id)}
                    >
                      <FontAwesome 
                        name={news.liked ? "heart" : "heart-o"} 
                        size={22} 
                        color={news.liked ? "#FF4757" : "#777777"} 
                      />
                    </StyledTouchableOpacity>
                  </StyledView>
                </StyledView>
              </StyledView>
            ))}
          </StyledView>
        </StyledView>

        <StyledView className="h-20" /> {/* Extra space at bottom */}
      </StyledScrollView>
    </StyledSafeAreaView>
  );
}