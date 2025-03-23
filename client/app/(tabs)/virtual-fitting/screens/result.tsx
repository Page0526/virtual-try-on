import React, { useEffect, useState } from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import * as FileSystem from 'expo-file-system';
import * as MediaLibrary from 'expo-media-library'; // Thêm expo-media-library
import * as Sharing from 'expo-sharing'; // Thêm expo-sharing
import { useRouter } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { useColorScheme } from '@/hooks/useColorScheme';
import { Ionicons } from '@expo/vector-icons';
import { SafeAreaView } from 'react-native-safe-area-context';

const ResultScreen = () => {
  const router = useRouter();
  const { resultUri } = useFittingContext();
  const colorScheme = useColorScheme();
  const [uriValid, setUriValid] = useState(true);

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
      if (!resultUri) {
        console.warn('No resultUri provided, redirecting to combine screen');
        setUriValid(false);
        router.push('/virtual-fitting/screens/combine');
        return;
      }

      const exists = await checkFileExists(resultUri);
      if (!exists) {
        console.warn('Result image does not exist, redirecting to combine screen');
        setUriValid(false);
        router.push('/virtual-fitting/screens/combine');
      }
    };

    validateUri();
  }, [resultUri, router]);

  // Logic để lưu ảnh vào thư viện
  const handleSave = async () => {
    try {
      // Kiểm tra và yêu cầu quyền truy cập media library
      const { status } = await MediaLibrary.requestPermissionsAsync();
      if (status !== 'granted') {
        Alert.alert(
          'Quyền bị từ chối',
          'Ứng dụng cần quyền truy cập thư viện ảnh để lưu ảnh. Vui lòng cấp quyền trong cài đặt.',
          [{ text: 'OK' }]
        );
        return;
      }

      // Lưu ảnh vào thư viện
      if (!resultUri) {
        Alert.alert('Lỗi', 'Không thể lưu ảnh. Vui lòng thử lại.');
        return;
      } else if (!(await checkFileExists(resultUri))) {
        await MediaLibrary.saveToLibraryAsync(resultUri);
        Alert.alert('Thành công', 'Ảnh đã được lưu vào thư viện ảnh!');
      }
    } catch (error) {
      console.error('Error saving image:', error);
      Alert.alert('Lỗi', 'Không thể lưu ảnh. Vui lòng thử lại.');
    }
  };

  // Logic để chia sẻ ảnh
  const handleShare = async () => {
    try {
      // Kiểm tra xem thiết bị có hỗ trợ chia sẻ không
      const isAvailable = await Sharing.isAvailableAsync();
      if (!isAvailable) {
        Alert.alert('Không hỗ trợ', 'Chia sẻ không khả dụng trên thiết bị này!');
        return;
      }

      if (resultUri) {
        // Chia sẻ ảnh
        await Sharing.shareAsync(resultUri, {
          dialogTitle: 'Chia sẻ ảnh kết quả',
        });
      }
    } catch (error) {
      console.error('Error sharing image:', error);
      Alert.alert('Lỗi', 'Không thể chia sẻ ảnh. Vui lòng thử lại.');
    }
  };

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
          source={{ uri: resultUri || '' }}
          style={styles.image}
          onError={(error) => console.error('Error loading result image:', error.nativeEvent.error)}
        />
      </View>

      {/* Khung thông điệp AI */}
      <View style={[styles.aiCommentBox, { backgroundColor: colorScheme === 'dark' ? '#1e1e1e' : '#f0f0f0' }]}>
        <Text style={[styles.aiComment, { color: colorScheme === 'dark' ? '#ccc' : '#333' }]}>
          Phù hợp cho dạo phố, thoải mái và năng động!
        </Text>
      </View>

      {/* Nút điều khiển */}
      <View style={styles.buttonContainer}>
        <TouchableOpacity style={styles.actionButton} onPress={handleSave}>
          <Ionicons name="save" size={24} color="#007AFF" />
          <Text style={styles.actionButtonText}>LƯU</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.actionButton} onPress={handleShare}>
          <Ionicons name="share-social" size={24} color="#007AFF" />
          <Text style={styles.actionButtonText}>CHIA SẺ</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.actionButton}
          onPress={() => router.push({
            pathname: '/virtual-fitting/screens/suggestions',
            params: { resultUri },
          })}
        >
          <Ionicons name="bulb" size={24} color="#007AFF" />
          <Text style={styles.actionButtonText}>GỢI Ý</Text>
        </TouchableOpacity>
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
    height: '70%',
    borderRadius: 20,
    overflow: 'hidden',
    marginBottom: 20,
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 5,
  },
  image: {
    flex: 1,
    resizeMode: 'cover',
  },
  aiCommentBox: {
    padding: 10,
    marginHorizontal: 20,
    borderRadius: 10,
    marginBottom: 20,
  },
  aiComment: {
    fontSize: 14,
    textAlign: 'center',
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 10,
    paddingHorizontal: 15,
  },
  actionButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#007AFF',
    marginLeft: 8,
  },
});

export default ResultScreen;