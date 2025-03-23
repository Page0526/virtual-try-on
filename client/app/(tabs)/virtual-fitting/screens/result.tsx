import React, { useEffect, useState } from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity, Alert, ActivityIndicator, ScrollView } from 'react-native';
import * as FileSystem from 'expo-file-system';
import * as MediaLibrary from 'expo-media-library';
import * as Sharing from 'expo-sharing';
import { useRouter } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { useColorScheme } from '@/hooks/useColorScheme';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { SafeAreaView } from 'react-native-safe-area-context';
import { BlurView } from 'expo-blur';
import { Asset } from 'expo-asset';

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

const ResultScreen = () => {
  const router = useRouter();
  const { resultUri } = useFittingContext();
  const colorScheme = useColorScheme();
  const [uriValid, setUriValid] = useState(true);
  const [loading, setLoading] = useState(false);
  const [imageLoaded, setImageLoaded] = useState(false);
  const [isCommentExpanded, setIsCommentExpanded] = useState(false);
  const [localImageUri, setLocalImageUri] = useState<string | null>(null);
  
  const isDark = colorScheme === 'dark';
  
  // Use orange-red theme colors
  const primaryColor = isDark ? orangeRedTheme.dark.tint : orangeRedTheme.light.tint;
  const bgColor = isDark ? orangeRedTheme.dark.background : orangeRedTheme.light.background;
  const textColor = isDark ? orangeRedTheme.dark.text : orangeRedTheme.light.text;
  const secondaryBgColor = isDark ? orangeRedTheme.dark.card : orangeRedTheme.light.card;
  const borderColor = isDark ? orangeRedTheme.dark.border : orangeRedTheme.light.border;

  // Define fallback asset (in case resultUri is invalid)
  // You need to replace 'require("../assets/default-result.jpg")' with your actual asset path
  const fallbackImage = require("@/assets/images/combine.png");

  // Load image from assets or URI
  useEffect(() => {
    const loadImage = async () => {
      try {
        // First check if resultUri exists and is valid
        if (resultUri) {
          // 
          const asset = Asset.fromModule(fallbackImage);
          await asset.downloadAsync();
          setLocalImageUri(asset.uri);
          setUriValid(true);
        }
        // If resultUri doesn't exist or is invalid, try to load from a specific asset
        // This could be modified to load a different asset based on some condition
        try {
          // This is an alternative approach using Asset module for more complex cases
          // You could add more fallback options here
          const asset = Asset.fromModule(fallbackImage);
          await asset.downloadAsync();
          setLocalImageUri(asset.uri);
          setUriValid(true);
        } catch (assetError) {
          console.error('Error loading fallback asset:', assetError);
          setUriValid(false);
          // Only redirect if all image loading attempts fail
          router.push('/virtual-fitting/screens/combine');
        }
      } catch (error) {
        console.error('Error in loadImage:', error);
        setUriValid(false);
        router.push('/virtual-fitting/screens/combine');
      }
    };

    loadImage();
  }, [resultUri, router]);

  // Check if file exists
  const checkFileExists = async (fileUri: string) => {
    try {
      const info = await FileSystem.getInfoAsync(fileUri);
      return info.exists;
    } catch (error) {
      console.error('Error checking file existence:', error);
      return false;
    }
  };

  // AI comment content
  const aiCommentText = `Phong cách và thiết kế
Thiết kế áo: Đây là một chiếc áo sơ mi ngắn tay, có cổ áo và hàng nút phía trước, với màu xanh nhạt và họa tiết sọc dọc tinh tế. Thiết kế này mang phong cách lịch sự nhưng vẫn thoải mái, phù hợp với môi trường công sở không quá trang trọng hoặc các dịp gặp gỡ thông thường.
Đặc điểm nổi bật: Áo có dáng ôm nhẹ, tôn dáng, và phần tay áo được gấp lên tạo cảm giác gọn gàng, năng động.
2. Sự phù hợp với dáng người
Dáng người lý tưởng: Áo sơ mi này sẽ phù hợp với những người có dáng người cân đối, không quá gầy hoặc quá mũm mĩm. Phần ôm nhẹ của áo giúp tôn lên vòng eo, nhưng nếu người mặc có vòng bụng lớn, áo có thể làm lộ khuyết điểm.
Chiều cao: Áo sơ mi ngắn tay thường phù hợp với người có chiều cao trung bình đến cao, vì tay áo ngắn có thể làm người thấp trông hơi mất cân đối.
Cánh tay: Nếu người mặc có cánh tay thon, áo sẽ rất tôn dáng. Tuy nhiên, nếu cánh tay to hoặc có nhiều khuyết điểm, tay áo ngắn có thể làm lộ phần này.
3. Màu sắc và làn da
Màu xanh nhạt: Màu sắc này khá nhẹ nhàng, dễ phối đồ và phù hợp với nhiều tông da, đặc biệt là da sáng hoặc trung bình. Với người có làn da ngăm, màu này có thể hơi nhạt, làm da trông kém tươi tắn nếu không kết hợp phụ kiện hoặc trang điểm phù hợp.
Họa tiết sọc dọc: Họa tiết này giúp tạo cảm giác cao và thon hơn, rất phù hợp với người có thân hình hơi tròn hoặc muốn kéo dài tỷ lệ cơ thể.
4. Bối cảnh sử dụng
Phù hợp: Áo sơ mi này lý tưởng cho môi trường công sở không quá nghiêm túc (ví dụ: văn phòng sáng tạo, công ty khởi nghiệp), hoặc các buổi gặp gỡ bạn bè, đi chơi nhẹ nhàng.
Không phù hợp: Nếu cần tham dự các sự kiện trang trọng (như hội nghị, tiệc tối), áo sơ mi ngắn tay có thể trông quá casual, không đủ lịch sự.`;

  // Create shortened version for collapsed view
  const getShortCommentText = () => {
    const words = aiCommentText.split(' ');
    return words.slice(0, 30).join(' ') + '...';
  };

  // Save image to library
  const handleSave = async () => {
    try {
      setLoading(true);
      const { status } = await MediaLibrary.requestPermissionsAsync();
      
      if (status !== 'granted') {
        Alert.alert(
          'Quyền bị từ chối',
          'Ứng dụng cần quyền truy cập thư viện ảnh để lưu ảnh. Vui lòng cấp quyền trong cài đặt.',
          [{ text: 'OK' }]
        );
        return;
      }

      if (!localImageUri) {
        Alert.alert('Lỗi', 'Không thể lưu ảnh. Vui lòng thử lại.');
        return;
      } 
      
      await MediaLibrary.saveToLibraryAsync(localImageUri);
      Alert.alert('Thành công', 'Ảnh đã được lưu vào thư viện ảnh!');
    } catch (error) {
      console.error('Error saving image:', error);
      Alert.alert('Lỗi', 'Không thể lưu ảnh. Vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  // Share image
  const handleShare = async () => {
    try {
      setLoading(true);
      const isAvailable = await Sharing.isAvailableAsync();
      
      if (!isAvailable) {
        Alert.alert('Không hỗ trợ', 'Chia sẻ không khả dụng trên thiết bị này!');
        return;
      }

      if (localImageUri) {
        await Sharing.shareAsync(localImageUri, {
          dialogTitle: 'Chia sẻ ảnh kết quả',
        });
      }
    } catch (error) {
      console.error('Error sharing image:', error);
      Alert.alert('Lỗi', 'Không thể chia sẻ ảnh. Vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  if (!uriValid && !localImageUri) {
    return null; // Wait for redirect if both URI and local assets are invalid
  }

  // Function to handle image loading failure
  const handleImageError = () => {
    // If external URI fails, try directly with require statement
    console.error('Error loading image from URI, using fallback asset directly');
    setImageLoaded(true); // Set to true to remove loading state
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bgColor }]}>
      <LinearGradient
        colors={isDark ? ['#1e1e1e', '#262626'] : ['#fff5f2', '#ffffff']}
        style={styles.gradientBackground}
      />
      
      {/* Header */}
      <View style={[styles.header, { backgroundColor: secondaryBgColor, borderBottomColor: borderColor }]}>
        <TouchableOpacity 
          style={styles.backButton}
          onPress={() => router.back()}
        >
          <Ionicons name="arrow-back" size={24} color={primaryColor} />
        </TouchableOpacity>
        
        <Text style={[styles.title, { color: textColor }]}>FITTING RESULT</Text>
        
        <TouchableOpacity 
          style={styles.closeButton}
          onPress={() => router.push('/(tabs)/shop/home')}
        >
          <Ionicons name="close" size={24} color={primaryColor} />
        </TouchableOpacity>
      </View>

      {/* Main Scrollable Content */}
      <ScrollView
        style={styles.scrollContainer}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.scrollContentContainer}
      >
        {/* Result Image Container */}
        <View style={styles.imageWrapper}>
          <View style={[styles.imageContainer, { backgroundColor: secondaryBgColor, borderColor }]}>
            {!imageLoaded && (
              <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color={primaryColor} />
                <Text style={[styles.loadingText, { color: textColor }]}>Đang tải hình ảnh...</Text>
              </View>
            )}
            
            {/* Conditional rendering based on image source */}
            {localImageUri ? (
              <Image
                source={{ uri: localImageUri }}
                style={styles.image}
                onLoad={() => setImageLoaded(true)}
                onError={handleImageError}
              />
            ) : (
              <Image
                source={fallbackImage}
                style={styles.image}
                onLoad={() => setImageLoaded(true)}
              />
            )}
          </View>
        </View>

        {/* AI Comment Box */}
        <BlurView 
          intensity={isDark ? 20 : 50} 
          tint={isDark ? 'dark' : 'light'} 
          style={styles.aiCommentWrapper}
        >
          <View style={[styles.aiCommentBox, { backgroundColor: isDark ? 'rgba(30, 30, 30, 0.8)' : 'rgba(255, 255, 255, 0.8)' }]}>
            <Ionicons name="sparkles" size={20} color={primaryColor} style={styles.aiIcon} />
            <View style={styles.aiCommentTextContainer}>
              <Text style={[styles.aiComment, { color: textColor }]}>
                {isCommentExpanded ? aiCommentText : getShortCommentText()}
              </Text>
              <TouchableOpacity 
                style={styles.readMoreButton} 
                onPress={() => setIsCommentExpanded(!isCommentExpanded)}
              >
                <Text style={[styles.readMoreButtonText, { color: primaryColor }]}>
                  {isCommentExpanded ? 'Thu gọn' : 'Xem thêm'}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </BlurView>

        {/* Action Buttons */}
        <View style={styles.actionButtonsContainer}>
          <TouchableOpacity 
            style={[styles.actionButton, { backgroundColor: isDark ? 'rgba(255, 69, 0, 0.2)' : 'rgba(255, 69, 0, 0.1)', borderColor }]} 
            onPress={handleSave}
            disabled={loading}
          >
            <Ionicons name="save" size={22} color={primaryColor} />
            <Text style={[styles.actionButtonText, { color: primaryColor }]}>SAVE</Text>
          </TouchableOpacity>

          <TouchableOpacity 
            style={[styles.actionButton, { backgroundColor: isDark ? 'rgba(255, 69, 0, 0.2)' : 'rgba(255, 69, 0, 0.1)', borderColor }]} 
            onPress={handleShare}
            disabled={loading}
          >
            <Ionicons name="share-social" size={22} color={primaryColor} />
            <Text style={[styles.actionButtonText, { color: primaryColor }]}>SHARE</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.actionButton, { backgroundColor: isDark ? 'rgba(255, 69, 0, 0.2)' : 'rgba(255, 69, 0, 0.1)', borderColor }]}
            onPress={() => router.push({
              pathname: '/virtual-fitting/screens/suggestions',
              params: { resultUri: localImageUri },
            })}
            disabled={loading}
          >
            <Ionicons name="bulb" size={22} color={primaryColor} />
            <Text style={[styles.actionButtonText, { color: primaryColor }]}>SUGGEST</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>

      {/* Suggestions Button (Fixed at bottom) */}
      <View style={styles.bottomButtonContainer}>
        <TouchableOpacity
          style={[styles.suggestionsButton, { backgroundColor: primaryColor }]}
          onPress={() => router.push('/virtual-fitting/screens/capture')}
          disabled={loading}
        >
          <Ionicons name="camera" size={20} color="#ffffff" style={styles.suggestionsButtonIcon} />
          <Text style={styles.suggestionsButtonText}>TRY AGAIN</Text>
        </TouchableOpacity>
      </View>

      {/* Loading Overlay */}
      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color={primaryColor} />
        </View>
      )}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
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
    borderBottomWidth: 1,
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
  title: {
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
    letterSpacing: 1,
    flex: 1,
  },
  scrollContainer: {
    flex: 1,
  },
  scrollContentContainer: {
    paddingHorizontal: 20,
    paddingBottom: 20,
  },
  imageWrapper: {
    alignItems: 'center',
    justifyContent: 'center',
    marginVertical: 20,
    height: 350, // Fixed height instead of percentage
  },
  imageContainer: {
    width: '100%',
    height: '100%',
    borderRadius: 20,
    overflow: 'hidden',
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.25,
    shadowRadius: 10,
    borderWidth: 1,
  },
  image: {
    flex: 1,
    resizeMode: 'cover',
  },
  loadingContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1,
  },
  loadingText: {
    marginTop: 10,
    fontSize: 14,
  },
  aiCommentWrapper: {
    borderRadius: 16,
    overflow: 'hidden',
    marginBottom: 20,
  },
  aiCommentBox: {
    padding: 16,
    borderRadius: 16,
    flexDirection: 'row',
    alignItems: 'flex-start',
  },
  aiIcon: {
    marginRight: 10,
    marginTop: 2,
  },
  aiCommentTextContainer: {
    flex: 1,
  },
  aiComment: {
    fontSize: 15,
    lineHeight: 22,
  },
  readMoreButton: {
    marginTop: 8,
    alignSelf: 'flex-end',
  },
  readMoreButtonText: {
    fontSize: 14,
    fontWeight: '600',
  },
  actionButtonsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 20,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    paddingHorizontal: 15,
    borderRadius: 12,
    flex: 1,
    marginHorizontal: 5,
    borderWidth: 1,
  },
  actionButtonText: {
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  bottomButtonContainer: {
    paddingHorizontal: 30,
    paddingBottom: 20,
    backgroundColor: 'transparent',
  },
  suggestionsButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 16,
    paddingHorizontal: 20,
    borderRadius: 30,
  },
  suggestionsButtonIcon: {
    marginRight: 8,
  },
  suggestionsButtonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '700',
    letterSpacing: 0.5,
  },
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0, 0, 0, 0.3)',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 999,
  },
});

export default ResultScreen;