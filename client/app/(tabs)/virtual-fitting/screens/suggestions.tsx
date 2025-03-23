import React, { useEffect, useState } from 'react';
import { View, Text, Image, StyleSheet, ScrollView } from 'react-native';
import * as FileSystem from 'expo-file-system';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useColorScheme } from '@/hooks/useColorScheme';
import { SafeAreaView } from 'react-native-safe-area-context';

const SuggestionsScreen = () => {
  const router = useRouter();
  const { resultUri } = useLocalSearchParams();
  const colorScheme = useColorScheme();
  const [uriValid, setUriValid] = useState(true);

  // Dữ liệu giả lập cho danh sách gợi ý
  const suggestions = [
    { id: 1, uri: 'https://via.placeholder.com/100', label: 'Công sở' },
    { id: 2, uri: 'https://via.placeholder.com/100', label: 'Dạo phố' },
    { id: 3, uri: 'https://via.placeholder.com/100', label: 'Tiệc tối' },
  ];

  // Kiểm tra xem file có tồn tại không
  const checkFileExists = async (fileUri: string) => {
    try {
      const info = await FileSystem.getInfoAsync(fileUri);
      return info.exists;
    } catch (error) {
      console.error('Error checking file existence:', error);
      return false;
    }
  };

  // Kiểm tra resultUri khi màn hình được tải
  useEffect(() => {
    const validateUri = async () => {
      const uri = typeof resultUri === 'string' ? resultUri : undefined;
      if (!uri) {
        console.warn('No resultUri provided, redirecting to result screen');
        setUriValid(false);
        router.push('/virtual-fitting/screens/result');
        return;
      }

      const exists = await checkFileExists(uri);
      if (!exists) {
        console.warn('Result image does not exist, redirecting to result screen');
        setUriValid(false);
        router.push('/virtual-fitting/screens/result');
      }
    };

    validateUri();
  }, [resultUri, router]);

  if (!uriValid) {
    return null; // Đợi redirect nếu URI không hợp lệ
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colorScheme === 'dark' ? '#121212' : '#fff' }]}>
      {/* Tiêu đề */}
      <Text style={[styles.title, { color: colorScheme === 'dark' ? '#fff' : '#333' }]}>
        FITTING ROOM
      </Text>

      {/* Khung chứa ảnh kết quả */}
      <View style={styles.imageContainer}>
        <Image
          source={{ uri: resultUri as string }}
          style={styles.resultImage}
          onError={(error) => console.error('Error loading result image:', error.nativeEvent.error)}
        />
      </View>

      {/* Tiêu đề gợi ý */}
      <Text style={[styles.suggestionTitle, { color: colorScheme === 'dark' ? '#fff' : '#333' }]}>
        Gợi ý phối đồ
      </Text>

      {/* Danh sách gợi ý */}
      <ScrollView horizontal style={styles.suggestionContainer} showsHorizontalScrollIndicator={false}>
        {suggestions.map((item) => (
          <View key={item.id} style={styles.suggestionItem}>
            <Image
              source={{ uri: item.uri }}
              style={styles.suggestionImage}
              onError={(error) => console.error(`Error loading suggestion image ${item.id}:`, error.nativeEvent.error)}
            />
            <Text style={[styles.suggestionLabel, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
              {item.label}
            </Text>
          </View>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 20,
    paddingTop: 40,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 20,
  },
  imageContainer: {
    width: '100%',
    height: '50%',
    borderRadius: 20,
    overflow: 'hidden',
    marginBottom: 20,
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 5,
  },
  resultImage: {
    flex: 1,
    resizeMode: 'cover',
  },
  suggestionTitle: {
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: 15,
  },
  suggestionContainer: {
    paddingVertical: 10,
  },
  suggestionItem: {
    alignItems: 'center',
    marginRight: 15,
  },
  suggestionImage: {
    width: 100,
    height: 100,
    borderRadius: 10,
  },
  suggestionLabel: {
    fontSize: 14,
    marginTop: 5,
  },
});

export default SuggestionsScreen;