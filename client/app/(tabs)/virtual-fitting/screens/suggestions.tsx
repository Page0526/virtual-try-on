import React, { useState, useEffect } from 'react';
import { View, Text, Image, StyleSheet, FlatList, TouchableOpacity, Dimensions, ActivityIndicator } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
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

type SuggestionItem = {
  id: number;
  uri: string;
  label: string;
  description: string;
  price?: number;
  brand?: string;
};

const SuggestionsScreen = () => {
  const router = useRouter();
  const params = useLocalSearchParams<{
    recommendations?: string;
    resultUri?: string;
  }>();
  const colorScheme = useColorScheme();
  
  const isDark = colorScheme === 'dark';
  const primaryColor = isDark ? orangeRedTheme.dark.tint : orangeRedTheme.light.tint;
  const bgColor = isDark ? orangeRedTheme.dark.background : orangeRedTheme.light.background;
  const textColor = isDark ? orangeRedTheme.dark.text : orangeRedTheme.light.text;
  const secondaryBgColor = isDark ? orangeRedTheme.dark.card : orangeRedTheme.light.card;
  const borderColor = isDark ? orangeRedTheme.dark.border : orangeRedTheme.light.border;
  const secondaryTextColor = isDark ? orangeRedTheme.dark.secondaryText : orangeRedTheme.light.secondaryText;

  const [suggestions, setSuggestions] = useState<SuggestionItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    try {
      if (params.recommendations) {
        const parsedRecs = JSON.parse(params.recommendations);
        if (Array.isArray(parsedRecs)) {
          setSuggestions(parsedRecs.map((item, index) => ({
            id: index,
            uri: item.image_urls?.[0] || '',
            label: item.title || 'Recommended Item',
            description: item.description || 'Great match for your style',
            price: item.price,
            brand: item.brand
          })));
        }
      }
    } catch (e) {
      setError('Failed to load recommendations');
      console.error('Error parsing recommendations:', e);
    } finally {
      setLoading(false);
    }
  }, [params.recommendations]);

  if (loading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: bgColor, justifyContent: 'center', alignItems: 'center' }]}>
        <ActivityIndicator size="large" color={primaryColor} />
        <Text style={[styles.loadingText, { color: textColor }]}>Loading recommendations...</Text>
      </SafeAreaView>
    );
  }

  if (error) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: bgColor, justifyContent: 'center', alignItems: 'center' }]}>
        <Text style={[styles.errorText, { color: textColor }]}>{error}</Text>
        <TouchableOpacity
          style={[styles.retryButton, { backgroundColor: primaryColor }]}
          onPress={() => router.back()}
        >
          <Text style={styles.retryButtonText}>Try Again</Text>
        </TouchableOpacity>
      </SafeAreaView>
    );
  }

  if (suggestions.length === 0) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: bgColor, justifyContent: 'center', alignItems: 'center' }]}>
        <Text style={[styles.noResultsText, { color: textColor }]}>No recommendations found</Text>
        <TouchableOpacity
          style={[styles.retryButton, { backgroundColor: primaryColor }]}
          onPress={() => router.back()}
        >
          <Text style={styles.retryButtonText}>Try Again</Text>
        </TouchableOpacity>
      </SafeAreaView>
    );
  }

  const renderSuggestionItem = ({ item }: { item: SuggestionItem }) => (
    <TouchableOpacity 
      style={[styles.suggestionItem, { backgroundColor: secondaryBgColor, borderColor }]}
      onPress={() => router.push({
        pathname: '/(tabs)/shop/product_detail',
        params: { 
          productId: item.id.toString(),
          productData: JSON.stringify(item)
        }
      })}
    >
      <Image
        source={{ uri: item.uri }}
        style={styles.suggestionImage}
        onError={() => console.log(`Error loading image for ${item.label}`)}
      />
      <View style={styles.suggestionContent}>
        <Text style={[styles.suggestionLabel, { color: textColor }]}>{item.label}</Text>
        {item.brand && <Text style={[styles.suggestionBrand, { color: secondaryTextColor }]}>{item.brand}</Text>}
        {item.price && <Text style={[styles.suggestionPrice, { color: primaryColor }]}>${item.price.toFixed(2)}</Text>}
        <Text style={[styles.suggestionDescription, { color: secondaryTextColor }]}>{item.description}</Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bgColor }]}>
      <LinearGradient
        colors={isDark ? ['#1e1e1e', '#262626'] : ['#fff5f2', '#ffffff']}
        style={styles.gradientBackground}
      />

      <View style={[styles.header, { backgroundColor: secondaryBgColor, borderBottomColor: borderColor }]}>
        <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
          <Ionicons name="arrow-back" size={24} color={primaryColor} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle, { color: textColor }]}>STYLING SUGGESTIONS</Text>
        <View style={{ width: 40 }} /> {/* Spacer */}
      </View>

      {params.resultUri && (
        <View style={[styles.imageContainer, { borderColor }]}>
          <Image
            source={{ uri: params.resultUri }}
            style={styles.resultImage}
            onError={() => console.log('Error loading result image')}
          />
        </View>
      )}

      <Text style={[styles.sectionTitle, { color: textColor }]}>Recommended For You</Text>

      <FlatList
        data={suggestions}
        renderItem={renderSuggestionItem}
        keyExtractor={(item) => item.id.toString()}
        numColumns={2}
        columnWrapperStyle={styles.suggestionRow}
        contentContainerStyle={styles.suggestionContainer}
      />
    </SafeAreaView>
  );
};

const { width } = Dimensions.get('window');
const columnWidth = (width - 60) / 2;

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
    borderBottomWidth: 1,
  },
  backButton: {
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
  },
  imageContainer: {
    width: '100%',
    height: 300,
    borderRadius: 20,
    overflow: 'hidden',
    marginBottom: 20,
    borderWidth: 1,
  },
  resultImage: {
    width: '100%',
    height: '100%',
    resizeMode: 'contain',
  },
  sectionTitle: {
    fontSize: 22,
    fontWeight: '700',
    marginBottom: 15,
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
    borderWidth: 1,
  },
  suggestionImage: {
    width: '100%',
    height: 150,
  },
  suggestionContent: {
    padding: 12,
  },
  suggestionLabel: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  suggestionBrand: {
    fontSize: 12,
    marginBottom: 4,
  },
  suggestionPrice: {
    fontSize: 14,
    fontWeight: '700',
    marginBottom: 4,
  },
  suggestionDescription: {
    fontSize: 12,
    lineHeight: 16,
  },
  loadingText: {
    marginTop: 15,
    fontSize: 16,
  },
  errorText: {
    fontSize: 16,
    marginBottom: 20,
    textAlign: 'center',
    paddingHorizontal: 20,
  },
  noResultsText: {
    fontSize: 16,
    marginBottom: 20,
  },
  retryButton: {
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 8,
  },
  retryButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
});

export default SuggestionsScreen;
