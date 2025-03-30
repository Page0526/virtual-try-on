import React, {useState} from 'react';
import { View, Text, Image, ScrollView, TextInput, TouchableOpacity, SafeAreaView, Platform, StatusBar, Dimensions, Animated, FlatList} from 'react-native';
import { Feather, AntDesign } from '@expo/vector-icons';
import { styled } from 'nativewind';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';


const StyledView = styled(View);
const StyledText = styled(Text);
const StyledImage = styled(Image);
const StyledTouchableOpacity = styled(TouchableOpacity);
const StyledScrollView = styled(ScrollView);
const { width, height } = Dimensions.get('window');

export default function SearchScreen() {
    const router = useRouter();
    const categories = ['All', 'Skirts', 'Jeans', 'Dress', 'T-s'];
    const [activeCategory, setActiveCategory] = useState('All');

    const products = [
        {
          id: '1',
          name: 'Charlee Skirts',
          price: 275.99,
          image: require('@/assets/images/skirt1.jpg'),
          category: 'Skirts'
        },
        {
          id: '2',
          name: 'Slim Fit Jeans',
          price: 149.99,
          image: require('@/assets/images/jeans1.jpg'),
          category: 'Jeans'
        },
        {
          id: '3',
          name: 'Casual T-shirt',
          price: 224.99,
          image: require('@/assets/images/tshirt.jpg'),
          category: 'T-s'
        },
        {
          id: '4',
          name: 'Hardy Skirts',
          price: 569.99,
          image: require('@/assets/images/skirt2.jpg'),
          category: 'Skirts'
        },
        {
          id: '5',
          name: 'Cassandre Jeans',
          price: 322.99,
          image: require('@/assets/images/jeans2.jpg'),
          category: 'Jeans'
        },
        {
          id: '6',
          name: 'Maxi Summer Dress',
          price: 270.99,
          image: require('@/assets/images/dress.jpg'),
          category: 'Dress'
        },
    ];

    // Filter products by selected category
    const filteredProducts = activeCategory === 'All' 
    ? products 
    : products.filter(product => product.category === activeCategory);

    // Handle category selection
    const handleCategoryPress = (categoryName: React.SetStateAction<string>) => {
    setActiveCategory(categoryName);
    };

    const handleProductPress = (productId: string) => {
        router.replace('/(tabs)/shop/product_detail');
    };

    return (
        <View className="flex-1 bg-white p-4">
        {/* Search Bar and Button */}
        <View className="flex-row items-center mt-5 w-full px-2">
            {/* Return Button */}
            <TouchableOpacity 
                className="mt-4 mr-3 -ml-2"
                onPress={() => router.push('/(tabs)/shop/home')}
            >
                <AntDesign name="arrowleft" size={24} color="#e14e69" />
            </TouchableOpacity>
            <View className="flex-1 flex-row pt-4 items-center">
            <TextInput
                placeholder="Search ...."
                className="w-[93%] h-[55px] bg-gray-100 rounded-[20px] text-gray-400 -mr-10 pl-4"
            />
            <TouchableOpacity onPress={() => console.log('Instagram icon pressed')}>
                {/* NOTE: Handle visual search */}
                <View className="p-2">
                    <AntDesign name="instagram" size={24} color="#CBC9C9" />
                </View>
            </TouchableOpacity>
            </View>
            <TouchableOpacity className="bg-[#e14e69] rounded-[20px] p-3 mt-4">
            <AntDesign name="search1" size={24} color="white" />
            </TouchableOpacity>
        </View>

        {/* Category Filters */}
        <View style={{ height: height * 0.08, marginBottom: height * 0.02, marginTop: height * 0.015 }}>
            <FlatList
                horizontal
                data={categories}
                keyExtractor={(item) => item}
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={{ paddingVertical: 10, gap: 10}}
                style={{ height: 50 }}  // Explicit height to control overflow
                renderItem={({ item }) => (
                    <TouchableOpacity
                        onPress={() => setActiveCategory(item)}
                        className={`h-10 px-5 py-2 rounded-[40px] ${
                            activeCategory === item ? 'bg-[#e14e69]' : 'bg-white border border-gray-200'
                        }`}
                    >
                        <Text className={activeCategory === item ? 'text-white' : 'text-gray-400'}>
                            {item}
                        </Text>
                    </TouchableOpacity>
                )}
            />
        </View>

        {/* Product Grid */}
        <StyledScrollView>
            <StyledView className="flex-row flex-wrap justify-between">
                {filteredProducts.map((product) => (
                <StyledTouchableOpacity 
                    key={product.id} 
                    className="bg-white rounded-xl shadow-md mb-4 w-[48%]"
                    onPress={() => handleProductPress(product.id)}
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
                        <StyledTouchableOpacity className="rounded-full p-1.5" style={{backgroundColor: Colors.PRIMARY}}>
                        <Feather name="shopping-bag" size={14} color="white" />
                        </StyledTouchableOpacity>
                    </StyledView>
                    </StyledView>
                </StyledTouchableOpacity>
                ))}
            </StyledView>
        </StyledScrollView>

        </View>
    );
}
