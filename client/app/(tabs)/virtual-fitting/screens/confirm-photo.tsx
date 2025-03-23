import React, { useEffect, useState } from 'react';
import { View, Text, Image, StyleSheet } from 'react-native';
import * as FileSystem from 'expo-file-system';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { useColorScheme } from '@/hooks/useColorScheme';
import Button from '@/components/Fitting-room/Button'; 
import { SafeAreaView } from 'react-native-safe-area-context';

const ConfirmPhotoScreen = () => {
  const router = useRouter();
  const { type, photoUri } = useLocalSearchParams();
  const { setGarmentUri, setModelUri } = useFittingContext();
  const colorScheme = useColorScheme();
  const [uriValid, setUriValid] = useState(true);

  // Kiểm tra và xử lý photoUri
  const uri = typeof photoUri === 'string' ? photoUri : undefined;
  console.log('Received photoUri in ConfirmPhotoScreen:', uri);

  // Kiểm tra file tồn tại
  useEffect(() => {
    const validateUri = async () => {
      if (!uri) {
        console.warn('No photoUri provided, redirecting to capture screen');
        setUriValid(false);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture', // Cập nhật đường dẫn
          params: { type },
        });
        return;
      }

      const exists = await FileSystem.getInfoAsync(uri);
      if (!exists.exists) {
        console.warn('Photo file does not exist, redirecting to capture screen');
        setUriValid(false);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture', // Cập nhật đường dẫn
          params: { type },
        });
      }
    };

    validateUri();
  }, [uri, router, type]);

  const confirmPhoto = () => {
    if (uri) {
      if (type === 'garment') {
        setGarmentUri(uri);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture', // Cập nhật đường dẫn
          params: { type: 'model' },
        });
      } else {
        setModelUri(uri);
        router.push('/(tabs)/virtual-fitting/screens/combine'); // Cập nhật đường dẫn
      }
    }
  };

  const retakePhoto = () => {
    router.push({
      pathname: '/(tabs)/virtual-fitting/screens/capture', // Cập nhật đường dẫn
      params: { type },
    });
  };

  if (!uriValid) {
    return null;
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colorScheme === 'dark' ? '#121212' : '#fff' }]}>
      {/* Tiêu đề */}
      <Text style={[styles.title, { color: colorScheme === 'dark' ? '#fff' : '#333' }]}>
        FITTING ROOM
      </Text>

      {/* Khung chứa ảnh preview */}
      <View style={styles.imageContainer}>
        <Image
          source={{ uri }}
          style={styles.previewImage}
          onError={(error) => console.error('Error loading image:', error.nativeEvent.error)}
        />
      </View>

      {/* Thông điệp hướng dẫn */}
      <Text style={[styles.instruction, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
        Please confirm if this photo looks good
      </Text>

      {/* Nút điều khiển */}
      <View style={styles.buttonContainer}>
        <Button title="CHỤP LẠI" onPress={retakePhoto} />
        <Button title="TIẾP TỤC" onPress={confirmPhoto} />
      </View>

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
    height: '60%',
    borderRadius: 20,
    overflow: 'hidden',
    marginBottom: 20,
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 5,
  },
  previewImage: {
    flex: 1,
    resizeMode: 'cover',
  },
  instruction: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 30,
    lineHeight: 22,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
});

export default ConfirmPhotoScreen;