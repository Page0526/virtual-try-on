import React, { useState, useEffect } from 'react';
import { View, Text, Image, StyleSheet, ActivityIndicator } from 'react-native';
import * as FileSystem from 'expo-file-system';
import { useRouter } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { useColorScheme } from '@/hooks/useColorScheme';
import StepIndicator from '@/components/Fitting-room/StepIndicator'; 
import Button from '@/components/Fitting-room/Button'; 
import { SafeAreaView } from 'react-native-safe-area-context';

const CombineScreen = () => {
  const router = useRouter();
  const { garmentUri, modelUri, setResultUri } = useFittingContext();
  const colorScheme = useColorScheme();
  const [loading, setLoading] = useState(false);
  const [urisValid, setUrisValid] = useState(true);

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

  // Kiểm tra cả garmentUri và modelUri khi màn hình được tải
  useEffect(() => {
    const validateUris = async () => {
      const garmentExists = garmentUri ? await checkFileExists(garmentUri) : false;
      const modelExists = modelUri ? await checkFileExists(modelUri) : false;

      if (!garmentExists || !modelExists) {
        console.warn('One or both URIs are invalid or files do not exist, redirecting...');
        setUrisValid(false);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture', // Cập nhật đường dẫn
          params: { type: !garmentExists ? 'garment' : 'model' },
        });
      }
    };

    validateUris();
  }, [garmentUri, modelUri, router]);

  const generateImage = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setResultUri(modelUri);
      router.push('/(tabs)/virtual-fitting/screens/result'); // Cập nhật đường dẫn
    }, 2000);
  };

  if (!urisValid) {
    return null;
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colorScheme === 'dark' ? '#121212' : '#fff' }]}>
      {/* Tiêu đề */}
      <Text style={[styles.title, { color: colorScheme === 'dark' ? '#fff' : '#333' }]}>
        FITTING ROOM
      </Text>

      {/* StepIndicator thay vì ProgressBar */}
      <StepIndicator
        currentStep={3}
        totalSteps={3}
        stepLabels={['Chụp ảnh quần áo', 'Chụp ảnh mẫu người', 'Kết hợp ảnh']}
      />

      {/* Khung chứa ảnh garment và model (theo chiều dọc) */}
      <View style={styles.imageContainer}>
        <View style={styles.imageWrapper}>
          <Text style={[styles.imageLabel, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
            Quần áo
          </Text>
          <Image
            source={{ uri: garmentUri || '' }}
            style={styles.image}
            onError={(error) => console.error('Error loading garment image:', error.nativeEvent.error)}
          />
        </View>
        <View style={styles.imageWrapper}>
          <Text style={[styles.imageLabel, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
            Mẫu người
          </Text>
          <Image
            source={{ uri: modelUri || '' }}
            style={styles.image}
            onError={(error) => console.error('Error loading model image:', error.nativeEvent.error)}
          />
        </View>
      </View>

      {/* Thông điệp hướng dẫn */}
      <Text style={[styles.instruction, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
        Please confirm the garment and model images before combining
      </Text>

      {/* Nút điều khiển */}
      <View style={styles.buttonContainer}>
        <Button
          title="RESTART"
          onPress={() => router.replace('/(tabs)/virtual-fitting/screens/capture')} // Cập nhật đường dẫn
          disabled={loading}
        />
        <Button title="TẠO ẢNH" onPress={generateImage} disabled={loading} />
      </View>

      {/* Nút Quay lại */}
      <Button
        title="QUAY LẠI"
        onPress={() => {
          router.push({
            pathname: '/(tabs)/virtual-fitting/screens/capture',
            params: { type: 'model' },
          });
        }}
        disabled={loading}
      />

      {/* Overlay khi đang xử lý */}
      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color="#007AFF" />
          <Text style={styles.loadingText}>Đang xử lý...</Text>
        </View>
      )}
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
    marginBottom: 10,
  },
  imageContainer: {
    flex: 1,
    flexDirection: 'column', // Sửa thành chiều dọc
    justifyContent: 'space-between', // Khoảng cách đều giữa hai ảnh
  },
  imageWrapper: {
    width: '100%',
    height: '48%', // Giảm chiều cao để vừa với layout dọc
    borderRadius: 20,
    overflow: 'hidden',
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 5,
  },
  imageLabel: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 5,
    textAlign: 'center',
  },
  image: {
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
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    color: '#fff',
    marginTop: 10,
  },
});

export default CombineScreen;