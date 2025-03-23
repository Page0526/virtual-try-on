import React, { useState } from 'react';
import { View, Text, Image, StyleSheet, FlatList, TouchableOpacity, Dimensions } from 'react-native';
import { useRouter } from 'expo-router';
import { useColorScheme } from '@/hooks/useColorScheme';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';

// Define orange-red theme colors
const orangeRedTheme = {
  primary: '#FF4500', // Orange-red
  secondary: '#FF6347', // Tomato
  light: {
    tint: '#FF4500',
    background: '#fff',
    text: '#333',
    secondaryText: '#666',
    card: '#fff',
    border: '#FFE4E1', // Misty rose
  },
  dark: {
    tint: '#FF6347',
    background: '#121212',
    text: '#fff',
    secondaryText: '#ccc',
    card: '#1e1e1e',
    border: '#462623', // Dark red-brown
  }
};

// Define type for suggestion item
type SuggestionItem = {
  id: number;
  uri: string;
  label: string;
  description: string;
};

const SuggestionsScreen = () => {
  const router = useRouter();
  const colorScheme = useColorScheme();
  
  const isDark = colorScheme === 'dark';
  
  // Use orange-red theme colors
  const primaryColor = isDark ? orangeRedTheme.dark.tint : orangeRedTheme.light.tint;
  const bgColor = isDark ? orangeRedTheme.dark.background : orangeRedTheme.light.background;
  const textColor = isDark ? orangeRedTheme.dark.text : orangeRedTheme.light.text;
  const secondaryBgColor = isDark ? orangeRedTheme.dark.card : orangeRedTheme.light.card;
  const borderColor = isDark ? orangeRedTheme.dark.border : orangeRedTheme.light.border;
  const secondaryTextColor = isDark ? orangeRedTheme.dark.secondaryText : orangeRedTheme.light.secondaryText;

  // Suggestion data with descriptions
  const suggestions: SuggestionItem[] = [
    { 
      id: 1, 
      uri: 'https://images-na.ssl-images-amazon.com/images/I/41rMU29qfBL.jpg', 
      label: 'Office Wear', 
      description: 'Suitable for professional office environments'
    },
    { 
      id: 2, 
      uri: 'https://dytbw3ui6vsu6.cloudfront.net/media/catalog/product/resize/780x780/S/a/Sandro_SFPPA01555-14_F_P_1.webp', 
      label: 'Casual', 
      description: 'Dynamic, comfortable style for weekends'
    },
    { 
      id: 3, 
      uri: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRulQO6l2VoxTTfN2kGyxT4zYNNt3Wej5fKqA&s', 
      label: 'Evening', 
      description: 'Elegant outfits for special occasions'
    },
    { 
      id: 4, 
      uri: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuiGQF3nZJxF6sfpXn2SK1MmC9SNm7dDS7_g&s', 
      label: 'Sporty', 
      description: 'Active and comfortable for sports activities'
    },
  ];

  // Center image - using a local import rather than reading from URI
  const centerImage = require("@/assets/images/combine.png");

  // Render a suggestion item
  const renderSuggestionItem = ({ item }: { item: SuggestionItem }) => (
    <TouchableOpacity 
      style={[styles.suggestionItem, { backgroundColor: secondaryBgColor, borderColor }]}
      onPress={() => console.log(`Selected style: ${item.label}`)}
    >
      <Image
        source={{ uri: item.uri }}
        style={styles.suggestionImage}
        onError={(error) => console.error(`Error loading suggestion image ${item.id}:`, error.nativeEvent.error)}
      />
      <View style={styles.suggestionContent}>
        <Text style={[styles.suggestionLabel, { color: textColor }]}>
          {item.label}
        </Text>
        <Text style={[styles.suggestionDescription, { color: secondaryTextColor }]}>
          {item.description}
        </Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bgColor }]} edges={['top', 'left', 'right']}>
      {/* Gradient Background */}
      <LinearGradient
        colors={isDark ? ['#1e1e1e', '#262626'] : ['#fff5f2', '#ffffff']}
        style={styles.gradientBackground}
      />

      {/* Header */}
      <View style={[styles.header, { backgroundColor: secondaryBgColor, borderBottomColor: borderColor, borderBottomWidth: 1 }]}>
        <TouchableOpacity
          style={styles.backButton}
          onPress={() => router.push('/virtual-fitting/screens/result')}
        >
          <Ionicons name="arrow-back" size={24} color={primaryColor} />
        </TouchableOpacity>
        
        <Text style={[styles.headerTitle, { color: textColor }]}>STYLING SUGGESTIONS</Text>
        
        <TouchableOpacity
          style={styles.closeButton}
          onPress={() => router.push('/(tabs)/shop/home')}
        >
          <Ionicons name="close" size={24} color={primaryColor} />
        </TouchableOpacity>
      </View>

      {/* Fixed center image container */}
      <View style={[styles.imageContainer, { borderColor }]}>
        <Image
          source={centerImage}
          style={styles.resultImage}
          onError={(error) => console.error('Error loading center image:', error.nativeEvent.error)}
        />
      </View>

      {/* Suggestions title */}
      <View style={styles.suggestionHeader}>
        <Text style={[styles.suggestionTitle, { color: textColor }]}>
          Outfit Suggestions
        </Text>
        <Text style={[styles.suggestionSubtitle, { color: secondaryTextColor }]}>
          Choose a style that suits you
        </Text>
      </View>

      {/* Suggestions list in 2-column grid */}
      <FlatList
        data={suggestions}
        renderItem={renderSuggestionItem}
        keyExtractor={(item) => item.id.toString()}
        numColumns={2}
        columnWrapperStyle={styles.suggestionRow}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.suggestionContainer}
      />
    </SafeAreaView>
  );
};

const { width } = Dimensions.get('window');
const columnWidth = (width - 60) / 2; // 60 = padding (40) + gap between columns (20)

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 20,
  },
  gradientBackground: {
    position: 'absolute',
    left: 0,
    right: 0,
    top: 0,
    bottom: 0,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    height: 50,
    paddingHorizontal: 10,
    marginBottom: 15,
  },
  backButton: {
    padding: 8,
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  closeButton: {
    padding: 8,
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
    letterSpacing: 1,
    flex: 1,
  },
  imageContainer: {
    width: '100%',
    height: '40%',
    borderRadius: 20,
    overflow: 'hidden',
    marginBottom: 20,
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 5,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  resultImage: {
    width: '100%',
    height: '100%',
    resizeMode: 'contain',
  },
  suggestionHeader: {
    marginBottom: 15,
  },
  suggestionTitle: {
    fontSize: 22,
    fontWeight: '700',
    textAlign: 'left',
  },
  suggestionSubtitle: {
    fontSize: 14,
    textAlign: 'left',
    marginTop: 4,
  },
  suggestionContainer: {
    paddingBottom: 20,
  },
  suggestionRow: {
    justifyContent: 'space-between',
    marginBottom: 16,
  },
  suggestionItem: {
    width: columnWidth,
    borderRadius: 16,
    overflow: 'hidden',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 3,
    borderWidth: 1,
  },
  suggestionImage: {
    width: '100%',
    height: 150,
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
  },
  suggestionContent: {
    padding: 12,
  },
  suggestionLabel: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  suggestionDescription: {
    fontSize: 12,
    lineHeight: 18,
  },
});

export default SuggestionsScreen;