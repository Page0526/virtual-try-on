import React, { useState, useEffect } from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, StatusBar, Platform, Pressable, ActivityIndicator, Dimensions, Alert } from 'react-native';
import { styled } from 'nativewind';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useCart, CartItem as CartItemType } from './cartContext';

// Styled components
const StyledView = styled(View);
const StyledText = styled(Text);
const StyledImage = styled(Image);
const StyledTouchableOpacity = styled(TouchableOpacity);
const StyledScrollView = styled(ScrollView);
const StyledPressable = styled(Pressable);

// Get screen dimensions
const { width: screenWidth } = Dimensions.get('window');

// Type for product data
type ProductData = {
  _id: string;
  name: string;
  brand: string;
  description: string;
  price: number;
  imageUrl: string;
  sizes: string[];
  colors: string[];
};

const ProductDetailScreen: React.FC = () => {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const { id } = useLocalSearchParams();

  const [product, setProduct] = useState<ProductData | null>(null);
  const [selectedSize, setSelectedSize] = useState<string | null>(null);
  const [selectedColor, setSelectedColor] = useState<string | null>(null);
  const [quantity, setQuantity] = useState(1);
  const [isLoading, setIsLoading] = useState(true);
  const [isImageLoading, setIsImageLoading] = useState(true);
  
  // Get cart functionality from context
  const { addToCart, getCartCount } = useCart();

  // Mock colors for the example
  const colorMap: Record<string, string> = {
    'red': '#E75D6F',
    'brown': '#8B4513',
    'black': '#000000',
    'gray': '#6e6e6e',
    'white': '#f5f5f5',
    'beige': '#d9bc9c',
    'olive': '#5d5d33',
  };

  useEffect(() => {
    // Mock data for now - this would be replaced with MongoDB fetch
    const fetchProduct = async () => {
      setIsLoading(true);
      try {
        // This would be the actual call to your MongoDB API
        // const response = await fetch(`your-api-endpoint/products/${id}`);
        // const data = await response.json();

        // Mock data
        const mockProduct: ProductData = {
          _id: '1',
          name: 'Kapital pant',
          brand: 'UNIQLO',
          description: 'Quần chino dáng rộng phù hợp với mọi phong cách thời trang. Chất liệu cotton thoáng mát, dễ chịu khi mặc.',
          price: 784000,
          // Remote image URL - must be HTTPS
          imageUrl: 'https://image.goat.com/transform/v1/attachments/product_template_additional_pictures/images/101/334/809/original/763724_01.jpg.jpeg?action=crop&width=1500',
          sizes: ['70CM', '73CM', '76CM', '79CM', '82CM', '85CM', '88CM'],
          colors: ['gray', 'black', 'white', 'beige', 'olive']
        };

        setProduct(mockProduct);
        // Set default selections
        if (mockProduct.sizes.length > 0) setSelectedSize(mockProduct.sizes[3]); // Default to 79CM
        if (mockProduct.colors.length > 0) setSelectedColor(mockProduct.colors[0]); // Default to gray
      } catch (error) {
        console.error('Error fetching product:', error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchProduct();
  }, [id]);

  const handleGoBack = () => {
    router.back();
  };

  const navigateToCart = () => {
    console.log('Navigating to cart screen');
    router.push('./cart');
  };

  const incrementQuantity = () => {
    setQuantity(prev => prev + 1);
  };

  const decrementQuantity = () => {
    if (quantity > 1) {
      setQuantity(prev => prev - 1);
    }
  };
  
  const handleAddToCart = () => {
    // Implement add to cart functionality
    if (!selectedSize || !selectedColor || !product) {
      Alert.alert('Thông báo', 'Vui lòng chọn kích thước và màu sắc');
      return;
    }

    const newItem: CartItemType = {
      id: product._id,
      name: product.name,
      price: product.price,
      size: selectedSize,
      color: selectedColor,
      quantity: quantity,
      image: product.imageUrl,
      inBundle: false
    };

    // Add to cart using context function
    addToCart(newItem);
    
    console.log('Added to cart:', {
      product: product._id,
      name: product.name,
      price: product.price,
      size: selectedSize,
      color: selectedColor,
      quantity: quantity
    });

    // Show success message
    Alert.alert('Thành công', 'Đã thêm sản phẩm vào giỏ hàng!', [
      {
        text: 'Tiếp tục mua sắm',
        onPress: () => console.log('Continue shopping')
      },
      {
        text: 'Xem giỏ hàng',
        onPress: () => navigateToCart()
      }
    ]);
  };

  if (isLoading || !product) {
    return (
      <StyledView className="flex-1 justify-center items-center">
        <StyledText className="text-lg">Đang tải...</StyledText>
      </StyledView>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: 'white', paddingTop: insets.top }}>
      <StatusBar barStyle="dark-content" />

      {/* Fixed Header */}
      <View style={{ 
        width: '100%', 
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 16,
        paddingVertical: 12,
        backgroundColor: 'white',
        zIndex: 10
      }}>
        <TouchableOpacity onPress={handleGoBack} style={{ padding: 8 }}>
          <Ionicons name="arrow-back" size={24} color="black" />
        </TouchableOpacity>

        <TouchableOpacity onPress={navigateToCart} style={{ padding: 8, position: 'relative' }}>
          <Ionicons name="cart-outline" size={24} color="black" />
          {getCartCount() > 0 && (
            <View style={{
              position: 'absolute',
              top: -5,
              right: -5,
              backgroundColor: '#E75D6F',
              borderRadius: 10,
              minWidth: 20,
              height: 20,
              justifyContent: 'center',
              alignItems: 'center',
              paddingHorizontal: 4,
            }}>
              <Text style={{ color: 'white', fontSize: 12, fontWeight: 'bold' }}>{getCartCount()}</Text>
            </View>
          )}
        </TouchableOpacity>
      </View>

      {/* Main ScrollView */}
      <ScrollView
        style={{ flex: 1 }}
        contentContainerStyle={{ paddingBottom: insets.bottom ? insets.bottom + 80 : 96 }}
        showsVerticalScrollIndicator={true}
        scrollEventThrottle={16}
        nestedScrollEnabled={true}
      >
        {/* Product Image with fixed height instead of aspect-square */}
        <View style={{ 
          width: screenWidth, 
          height: screenWidth, 
          backgroundColor: '#f5f5f5',
          marginBottom: 16 
        }}>
          {isImageLoading && (
            <View style={{
              position: 'absolute',
              top: 0, left: 0, right: 0, bottom: 0,
              justifyContent: 'center',
              alignItems: 'center',
              zIndex: 10
            }}>
              <ActivityIndicator size="large" color="#000" />
            </View>
          )}
          <Image
            source={{ uri: product.imageUrl }}
            style={{
              width: '100%',
              height: '100%',
            }}
            resizeMode="contain"
            onLoadStart={() => setIsImageLoading(true)}
            onLoadEnd={() => setIsImageLoading(false)}
            onError={(e) => {
              setIsImageLoading(false);
              console.error('Image loading error:', e.nativeEvent.error);
            }}
          />
        </View>

        {/* Product Info */}
        <StyledView className="px-6 mb-6">
          {/* Product name - larger and indented */}
          <StyledText style={{ 
            fontSize: 28, 
            fontWeight: 'bold', 
            marginBottom: 16,
            paddingLeft: 8, // Indentation
            borderLeftWidth: 3,
            borderLeftColor: '#FFF',
            paddingVertical: 4
          }}>
            {product.name}
          </StyledText>
        </StyledView>

        {/* Color Selection */}
        <View style={{ paddingHorizontal: 24, marginBottom: 24 }}>
          <Text style={{ fontSize: 14, color: '#6b7280', marginBottom: 8 }}>
            Màu sắc: {selectedColor === 'gray' ? '07 GRAY' : selectedColor}
          </Text>
          <View style={{ flexDirection: 'row' }}>
            {product.colors.map((color) => (
              <TouchableOpacity
                key={color}
                onPress={() => setSelectedColor(color)}
                style={{
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  backgroundColor: colorMap[color] || color,
                  marginRight: 12,
                  justifyContent: 'center',
                  alignItems: 'center',
                  borderWidth: selectedColor === color ? 4 : 0,
                  borderColor: 'rgba(150,150,150,0.5)'
                }}
              />
            ))}
          </View>
        </View>

        {/* Size Selection */}
        <View style={{ paddingHorizontal: 24, marginBottom: 24 }}>
          <Text style={{ fontSize: 14, color: '#6b7280', marginBottom: 8 }}>Kích thước: {selectedSize}</Text>
          <ScrollView 
            horizontal 
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{ flexDirection: 'row', paddingRight: 16 }}
          >
            {product.sizes.map((size) => (
              <TouchableOpacity
                key={size}
                onPress={() => setSelectedSize(size)}
                style={{
                  width: 70,
                  height: 40,
                  borderWidth: selectedSize === size ? 2 : 1,
                  borderColor: selectedSize === size ? '#000' : '#d1d5db',
                  borderRadius: 6,
                  justifyContent: 'center',
                  alignItems: 'center',
                  backgroundColor: 'white',
                  marginRight: 8
                }}
              >
                <Text style={{ 
                  fontWeight: selectedSize === size ? 'bold' : 'normal' 
                }}>
                  {size}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* Quantity Selection and Price in one row */}
        <View style={{ 
          paddingHorizontal: 24, 
          marginBottom: 30,
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}>
          {/* Price - styled like product name */}
          <View style={{ 
            flex: 1,
            paddingLeft: 8,
            borderLeftWidth: 3,
            borderLeftColor: '#000',
          }}>
            <Text style={{ 
              fontSize: 26, 
              fontWeight: 'bold',
            }}>
              {product.price.toLocaleString('vi-VN')} $
            </Text>
          </View>

          {/* Quantity Selector */}
          <View className="bg-gray-100 flex-row items-center justify-between rounded-full px-4 py-2 w-36">
            <TouchableOpacity onPress={decrementQuantity}>
              <Text style={{ fontSize: 22, fontWeight: '300' }}>-</Text>
            </TouchableOpacity>

            <Text style={{ fontSize: 18 }}>{quantity}</Text>

            <TouchableOpacity onPress={incrementQuantity}>
              <Text style={{ fontSize: 22, fontWeight: '300' }}>+</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Empty space where Add to Cart Button was */}
        <View style={{ height: 20 }} />

        {/* Product Details */}
        <View style={{ paddingHorizontal: 24, marginBottom: 80 }}>
          <Text style={{ fontSize: 16, fontWeight: 'bold', marginBottom: 8 }}>Thông tin sản phẩm</Text>
          <Text style={{ color: '#4b5563', lineHeight: 20 }}>
            Mã sản phẩm: 475564
          </Text>
        </View>
      </ScrollView>
      
      {/* Fixed Footer with Add to Cart Button */}
      <View style={{
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        backgroundColor: 'white',
        paddingHorizontal: 16,
        paddingTop: 12,
        paddingBottom: insets.bottom ? insets.bottom + 8 : 16,
        borderTopWidth: 1,
        borderTopColor: '#f0f0f0',
        elevation: 8,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: -3 },
        shadowOpacity: 0.1,
        shadowRadius: 3,
      }}>
        <Pressable
          onPress={handleAddToCart}
          style={({ pressed }) => [
            { opacity: pressed ? 0.8 : 1 },
            pressed ? { transform: [{ translateY: 2 }] } : {}
          ]}
        >
          <View style={{
            backgroundColor: 'black',
            borderRadius: 9999,
            paddingVertical: 16,
            alignItems: 'center'
          }}>
            <Text style={{
              color: 'white',
              fontWeight: 'bold',
              fontSize: 18
            }}>THÊM VÀO GIỎ HÀNG</Text>
          </View>
        </Pressable>
      </View>
    </View>
  );
};

export default ProductDetailScreen;