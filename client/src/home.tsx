import React from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, TextInput, StatusBar } from 'react-native';
import { styled } from 'nativewind';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Ionicons, FontAwesome } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

// Styled components
const StyledView = styled(View);
const StyledText = styled(Text);
const StyledImage = styled(Image);
const StyledTouchableOpacity = styled(TouchableOpacity);
const StyledScrollView = styled(ScrollView);
const StyledTextInput = styled(TextInput);

// Sample data for recent outfits
const recentOutfits = [
    {
        id: '1',
        image: require('@/assets/images/sky.png'),
    },
    {
        id: '2',
        image: require('@/assets/images/background.png'),
    },
];

// Sample data for most ordered products
const mostOrderedProducts = [
    {
        id: '1',
        image: require('@/assets/images/sky.png'),
        name: 'Blue Floral Dress',
        price: 1200,
    },
    {
        id: '2',
        image: require('@/assets/images/background.png'),
        name: 'White Summer Top',
        price: 800,
    },
];

// Filter categories
const categories = [
    { id: 'all', name: 'All' },
    { id: 'skirt', name: 'Skirt' },
    { id: 'jeans', name: 'Jeans' },
    { id: 'dress', name: 'Dress' },
    { id: 't-shirt', name: 'T-shirt' },
];

const HomeScreen: React.FC = () => {
    const insets = useSafeAreaInsets();
    const router = useRouter();
    const [activeCategory, setActiveCategory] = React.useState('all');

    const handleProductPress = (productId: string) => {
        // Navigate to product detail screen
        router.push(`../shop/product_details?id=${productId}`);
    };

    const handleCategoryPress = (categoryId: string) => {
        setActiveCategory(categoryId);
    };

    const navigateTo = (screen: string) => {
        if (screen === 'cart') {
            router.push('../cart');
        } else if (screen === 'fitting_room') {
            router.push('../fitting_room');
        } else if (screen === 'stylemate') {
            router.push('../stylemate');
        } else if (screen === 'closet') {
            router.push('../closet');
        }
    };

    return (
        <StyledView className="flex-1 bg-white" style={{ paddingTop: insets.top }}>
            <StatusBar barStyle="dark-content" />

            {/* Header with welcome message */}
            <StyledView className="flex-row justify-between items-center px-4 py-1.5">
                <StyledView>
                    <StyledText className="text-sm font-medium">Welcome back,</StyledText>
                    <StyledText className="text-base text-[#E75D6F] font-semibold">Tuoc Nguyen</StyledText>
                </StyledView>
            </StyledView>

            {/* Search bar */}
            <StyledView className="px-4 mb-2">
                <StyledView className="flex-row items-center bg-gray-100 rounded-full px-3 py-1">
                    <Ionicons name="search" size={16} color="#666" />
                    <StyledTextInput
                        placeholder="Search"
                        className="flex-1 ml-1.5 text-xs"
                        placeholderTextColor="#999"
                    />
                    <Ionicons name="mic" size={16} color="#666" />
                </StyledView>
            </StyledView>

            <StyledScrollView className="flex-1">
                {/* Recent outfits section */}
                <StyledView className="mb-3">
                    <StyledText className="text-lg font-bold px-4 mb-2">Recent outfits</StyledText>
                    <ScrollView horizontal showsHorizontalScrollIndicator={false} className="pl-4">
                        {recentOutfits.map((outfit) => (
                            <StyledTouchableOpacity
                                key={outfit.id}
                                className="mr-2 rounded-lg overflow-hidden"
                                onPress={() => handleProductPress(outfit.id)}
                            >
                                <StyledImage
                                    source={outfit.image}
                                    className="w-8 h-8 rounded-lg"
                                    resizeMode="cover"
                                />
                            </StyledTouchableOpacity>
                        ))}
                    </ScrollView>
                </StyledView>

                {/* Most ordered section */}
                <StyledView>
                    <StyledView className="flex-row items-center px-4 mb-2">
                        <StyledText className="text-lg font-bold">Most ordered</StyledText>
                        <StyledText className="ml-1 text-lg text-[#E75D6F]">❣️</StyledText>
                    </StyledView>

                    {/* Category filter */}
                    <ScrollView
                        horizontal
                        showsHorizontalScrollIndicator={false}
                        className="pl-4 mb-2"
                    >
                        {categories.map((category) => (
                            <StyledTouchableOpacity
                                key={category.id}
                                className={`mr-2 px-3 py-1 rounded-full ${activeCategory === category.id ? 'bg-[#E75D6F]' : 'bg-[#f2a4ad]'}`}
                                onPress={() => handleCategoryPress(category.id)}
                            >
                                <StyledText className={`${activeCategory === category.id ? 'text-white' : 'text-white'} text-xs font-medium`}>
                                    {category.name}
                                </StyledText>
                            </StyledTouchableOpacity>
                        ))}
                    </ScrollView>

                    {/* Product grid */}
                    <StyledView className="flex-row flex-wrap px-2">
                        {mostOrderedProducts.map((product) => (
                            <StyledTouchableOpacity
                                key={product.id}
                                className="w-1/2 p-1.5"
                                onPress={() => handleProductPress(product.id)}
                            >
                                <StyledView className="bg-gray-50 rounded-lg overflow-hidden">
                                    <StyledImage
                                        source={product.image}
                                        className="w-full h-28"
                                        resizeMode="cover"
                                    />
                                    <StyledView className="p-1.5">
                                        <StyledText className="text-xs font-medium" numberOfLines={1}>{product.name}</StyledText>
                                        <StyledText className="text-[#E75D6F] text-sm font-bold">Rs. {product.price}</StyledText>
                                    </StyledView>
                                </StyledView>
                            </StyledTouchableOpacity>
                        ))}
                    </StyledView>
                </StyledView>

                {/* Add some padding at the bottom for the navigation bar */}
                <StyledView style={{ height: 80 }} />
            </StyledScrollView>
        </StyledView>
    );
};

export default HomeScreen;