import React, { useRef, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image, Modal, FlatList, TouchableWithoutFeedback, StatusBar, Platform } from 'react-native';
import { CameraView, CameraType, useCameraPermissions } from 'expo-camera';
import * as ImagePicker from 'expo-image-picker';
import * as FileSystem from 'expo-file-system';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { useColorScheme } from '@/hooks/useColorScheme';
import { Ionicons } from '@expo/vector-icons';
import StepIndicator from '@/components/Fitting-room/StepIndicator';
import { Colors } from '@/constants/Colors';
import { SafeAreaView } from 'react-native-safe-area-context';

// Dữ liệu giả lập
const mockGarments = [
  { id: '1', name: 'Blue Dress', uri: 'https://via.placeholder.com/100?text=Blue+Dress' },
  { id: '2', name: 'Red Shirt', uri: 'https://via.placeholder.com/100?text=Red+Shirt' },
  { id: '3', name: 'Black Pants', uri: 'https://via.placeholder.com/100?text=Black+Pants' },
];

const mockModels = [
  { id: '1', name: 'Model 1', uri: 'https://via.placeholder.com/100?text=Model+1' },
  { id: '2', name: 'Model 2', uri: 'https://via.placeholder.com/100?text=Model+2' },
  { id: '3', name: 'Model 3', uri: 'https://via.placeholder.com/100?text=Model+3' },
];

const CaptureScreen = () => {
  const router = useRouter();
  const { type } = useLocalSearchParams();
  const { setGarmentUri, setModelUri } = useFittingContext();
  const [facing, setFacing] = useState<CameraType>('back');
  const [permission, requestPermission] = useCameraPermissions();
  const cameraRef = useRef<CameraView>(null);
  const colorScheme = useColorScheme();
  const [modalVisible, setModalVisible] = useState(false);

  const tintColor = Colors[colorScheme ?? 'light'].tint;
  const backgroundColor = colorScheme === 'dark' ? '#121212' : '#fff';
  const textColor = colorScheme === 'dark' ? '#fff' : '#333';

  if (!permission) {
    return <View />;
  }

  if (!permission.granted) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor }]} edges={['top', 'left', 'right']}>
        <StatusBar barStyle={colorScheme === 'dark' ? 'light-content' : 'dark-content'} />
        <CustomHeader
          title="Capture"
          colorScheme={colorScheme}
          tintColor={tintColor}
        />
        <View style={styles.permissionContainer}>
          <Text style={[styles.message, { color: textColor }]}>We need camera access to proceed</Text>
          <TouchableOpacity style={[styles.permissionButton, { backgroundColor: tintColor }]} onPress={requestPermission}>
            <Text style={styles.buttonText}>Grant Permission</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  const takePicture = async () => {
    if (cameraRef.current) {
      const photo = await cameraRef.current.takePictureAsync();
      if (photo && photo.uri) {
        const newUri = `${FileSystem.cacheDirectory}fitting-room-${Date.now()}.jpg`;
        await FileSystem.copyAsync({ from: photo.uri, to: newUri });
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/confirm-photo',
          params: { type, photoUri: newUri },
        });
      }
    }
  };

  const toggleCameraFacing = () => {
    setFacing(current => (current === 'back' ? 'front' : 'back'));
  };

  const pickImage = async () => {
    const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (status !== 'granted') {
      alert('Sorry, we need media library permissions to make this work!');
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      quality: 1,
    });

    if (!result.canceled && result.assets && result.assets.length > 0) {
      const uri = result.assets[0].uri;
      const newUri = `${FileSystem.cacheDirectory}fitting-room-${Date.now()}.jpg`;
      await FileSystem.copyAsync({ from: uri, to: newUri });
      router.push({
        pathname: '/(tabs)/virtual-fitting/screens/confirm-photo',
        params: { type, photoUri: newUri },
      });
    }
  };

  const selectItem = (uri: string) => {
    if (type === 'garment') {
      setGarmentUri(uri);
      router.push({
        pathname: '/(tabs)/virtual-fitting/screens/confirm-photo',
        params: { type, photoUri: uri },
      });
    } else {
      setModelUri(uri);
      router.push('/(tabs)/virtual-fitting/screens/combine');
    }
    setModalVisible(false);
  };

  const renderItem = ({ item }: { item: { id: string; name: string; uri: string } }) => (
    <TouchableOpacity style={styles.item} onPress={() => selectItem(item.uri)}>
      <Image source={{ uri: item.uri }} style={styles.itemImage} />
      <Text style={[styles.itemText, { color: textColor }]}>{item.name}</Text>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={[styles.container, { backgroundColor }]} edges={['top', 'left', 'right']}>
      <StatusBar barStyle={colorScheme === 'dark' ? 'light-content' : 'dark-content'} />
      <CustomHeader
        title={type === 'garment' ? 'Capture Garment' : 'Capture Model'}
        colorScheme={colorScheme}
        tintColor={tintColor}
      />
      <View style={styles.contentContainer}>
        <StepIndicator
          currentStep={type === 'garment' ? 1 : 2}
          totalSteps={3}
          stepLabels={['Chụp ảnh quần áo', 'Chụp ảnh mẫu người', 'Kết hợp ảnh']}
        />
        {type === 'garment' && (
          <Text style={[styles.instruction, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
            Chụp ảnh quần áo để bắt đầu thử đồ!
          </Text>
        )}
        <View style={styles.cameraContainer}>
          <CameraView style={styles.camera} facing={facing} ref={cameraRef} />
          <TouchableOpacity style={styles.toggleCameraButton} onPress={toggleCameraFacing}>
            <Ionicons name="camera-reverse" size={24} color="#fff" />
          </TouchableOpacity>
        </View>
        <Text style={[styles.instruction, { color: colorScheme === 'dark' ? '#ccc' : '#666' }]}>
          Choose a well-lit, high-quality photo that clearly captures your entire body
        </Text>
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={styles.actionButton} onPress={pickImage}>
            <Ionicons name="image" size={20} color={tintColor} />
            <Text style={[styles.actionButtonText, { color: tintColor }]}>PHOTO</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.captureButton} onPress={takePicture}>
            <View style={[styles.captureInner, { backgroundColor: tintColor }]} />
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionButton} onPress={() => setModalVisible(true)}>
            <Ionicons name="shirt" size={20} color={tintColor} />
            <Text style={[styles.actionButtonText, { color: tintColor }]}>
              {type === 'garment' ? 'MY CLOTHES' : 'MY MODEL'}
            </Text>
          </TouchableOpacity>
        </View>
      </View>
      <Modal animationType="slide" transparent={true} visible={modalVisible} onRequestClose={() => setModalVisible(false)}>
        <TouchableWithoutFeedback onPress={() => setModalVisible(false)}>
          <View style={styles.modalOverlay}>
            <TouchableWithoutFeedback>
              <View style={[styles.modalContainer, { backgroundColor: colorScheme === 'dark' ? '#1e1e1e' : '#fff' }]}>
                <Text style={[styles.modalTitle, { color: textColor }]}>
                  {type === 'garment' ? 'My Clothes' : 'My Models'}
                </Text>
                <FlatList
                  data={type === 'garment' ? mockGarments : mockModels}
                  renderItem={renderItem}
                  keyExtractor={(item) => item.id}
                  style={styles.itemList}
                  horizontal
                />
                <TouchableOpacity style={[styles.closeButton, { backgroundColor: tintColor }]} onPress={() => setModalVisible(false)}>
                  <Text style={styles.closeButtonText}>Close</Text>
                </TouchableOpacity>
              </View>
            </TouchableWithoutFeedback>
          </View>
        </TouchableWithoutFeedback>
      </Modal>
    </SafeAreaView>
  );
};

// Custom Header Component
type CustomHeaderProps = {
  title: string;
  colorScheme: string | null | undefined;
  tintColor: string;
};

const CustomHeader = ({ title, colorScheme, tintColor }: CustomHeaderProps) => {
  const backgroundColor = colorScheme === 'dark' ? '#1e1e1e' : '#fff';
  const textColor = colorScheme === 'dark' ? '#fff' : '#333';

  return (
    <View style={[styles.header, { backgroundColor }]}>
      <Text style={[styles.headerTitle, { color: textColor }]}>{title}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    alignItems: 'center',
    height: 44,
    width: '100%',
    paddingHorizontal: 10,
    justifyContent: 'center',
  },
  headerTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  contentContainer: {
    flex: 1,
    paddingHorizontal: 15,
    paddingBottom: 20, // Đảm bảo không bị che bởi thanh điều hướng
  },
  permissionContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  cameraContainer: {
    width: '100%',
    height: '60%',
    borderRadius: 30,
    overflow: 'hidden',
    marginBottom: 15,
    position: 'relative',
  },
  camera: {
    flex: 1,
  },
  toggleCameraButton: {
    position: 'absolute',
    bottom: 10,
    right: 10,
    backgroundColor: 'transparent',
    borderRadius: 20,
    padding: 8,
  },
  instruction: {
    fontSize: 12,
    textAlign: 'center',
    marginVertical: 8,
    lineHeight: 16,
    color: '#666',
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    marginTop: 10,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    paddingHorizontal: 15,
    borderRadius: 20,
    backgroundColor: '#fff',
    borderWidth: 1,
    borderColor: '#ddd',
  },
  actionButtonText: {
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  captureButton: {
    width: 60,
    height: 60,
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
  captureInner: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: '#007AFF',
  },
  permissionButton: {
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 25,
  },
  message: {
    textAlign: 'center',
    fontSize: 16,
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'flex-end',
  },
  modalContainer: {
    height: '50%',
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    padding: 20,
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 15,
  },
  itemList: {
    flex: 1,
  },
  item: {
    marginRight: 15,
    alignItems: 'center',
  },
  itemImage: {
    width: 100,
    height: 100,
    borderRadius: 10,
  },
  itemText: {
    fontSize: 14,
    marginTop: 5,
    textAlign: 'center',
  },
  closeButton: {
    paddingVertical: 12,
    borderRadius: 25,
    marginTop: 15,
    alignSelf: 'center',
    width: '50%',
  },
  closeButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
    textAlign: 'center',
  },
  buttonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
  },
});

export default CaptureScreen;