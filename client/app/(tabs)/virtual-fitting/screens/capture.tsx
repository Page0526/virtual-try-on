import React, { useRef, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image, Modal, FlatList, TouchableWithoutFeedback, StatusBar, Platform, ScrollView } from 'react-native';
import { CameraView, CameraType, useCameraPermissions } from 'expo-camera';
import * as ImagePicker from 'expo-image-picker';
import * as FileSystem from 'expo-file-system';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { useColorScheme } from '@/hooks/useColorScheme';
import { Ionicons } from '@expo/vector-icons';
import StepIndicator from '@/components/Fitting-room/StepIndicator';
import { SafeAreaView } from 'react-native-safe-area-context';
import { BlurView } from 'expo-blur';
import { Colors } from '@/constants/Colors';
import { styled } from 'nativewind';


const StyledScrollView = styled(ScrollView);

// Define orange-red theme colors
const orangeRedTheme = {
  secondary: '#FF6347', // Tomato
  light: {
    tint: '#e14E69',
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

// Mock data
const mockGarments = [
  { id: '1', name: 'Blue Dress', uri: 'https://via.placeholder.com/100?text=Blue+Dress' },
  { id: '2', name: 'Red Shirt', uri: 'https://via.placeholder.com/100?text=Red+Shirt' },
  { id: '3', name: 'Black Pants', uri: 'https://via.placeholder.com/100?text=Black+Pants' },
  { id: '4', name: 'Green Jacket', uri: 'https://via.placeholder.com/100?text=Green+Jacket' },
  { id: '5', name: 'Yellow Skirt', uri: 'https://via.placeholder.com/100?text=Yellow+Skirt' },
];

const mockModels = [
  { id: '1', name: 'Model 1', uri: 'https://via.placeholder.com/100?text=Model+1' },
  { id: '2', name: 'Model 2', uri: 'https://via.placeholder.com/100?text=Model+2' },
  { id: '3', name: 'Model 3', uri: 'https://via.placeholder.com/100?text=Model+3' },
  { id: '4', name: 'Model 4', uri: 'https://via.placeholder.com/100?text=Model+4' },
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

  const tintColor = colorScheme === 'dark' ? orangeRedTheme.dark.tint : orangeRedTheme.light.tint;
  const backgroundColor = colorScheme === 'dark' ? orangeRedTheme.dark.background : orangeRedTheme.light.background;
  const textColor = colorScheme === 'dark' ? orangeRedTheme.dark.text : orangeRedTheme.light.text;
  const secondaryTextColor = colorScheme === 'dark' ? orangeRedTheme.dark.secondaryText : orangeRedTheme.light.secondaryText;
  const cardColor = colorScheme === 'dark' ? orangeRedTheme.dark.card : orangeRedTheme.light.card;
  const borderColor = colorScheme === 'dark' ? orangeRedTheme.dark.border : orangeRedTheme.light.border;

  const isGarmentMode = type === 'garment';
  const title = isGarmentMode ? 'CAPTURE GARMENT' : 'CAPTURE MODEL';
  const instruction = isGarmentMode 
    ? 'Place the garment on a flat surface with good lighting to capture'
    : 'Stand in front of a plain background with good lighting for a full-body photo';
  const galleryText = isGarmentMode ? 'MY CLOTHES' : 'MY MODELS';

  const goBack = () => {
    router.back();
  };

  const goHome = () => {
    router.navigate('/(tabs)/shop/home');
  };

  if (!permission) {
    return <View />;
  }

  if (!permission.granted) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor }]} edges={['top', 'left', 'right']}>
        <StatusBar barStyle={colorScheme === 'dark' ? 'light-content' : 'dark-content'} />
        <CustomHeader
          title="Camera Access"
          colorScheme={colorScheme}
          tintColor={tintColor}
          borderColor={borderColor}
          onBackPress={goBack}
          onClosePress={goHome}
        />
        <View style={styles.permissionContainer}>
          <Ionicons name="camera-outline" size={64} color={secondaryTextColor} style={styles.permissionIcon} />
          <Text style={[styles.permissionTitle, { color: textColor }]}>Camera access is required</Text>
          <Text style={[styles.permissionDescription, { color: secondaryTextColor }]}>
            We need camera access to capture photos for the virtual fitting experience
          </Text>
          <TouchableOpacity 
            style={[styles.permissionButton, { backgroundColor: tintColor }]} 
            onPress={requestPermission}
          >
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
    if (isGarmentMode) {
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
    <TouchableOpacity 
      style={[styles.item, { borderColor }]} 
      onPress={() => selectItem(item.uri)}
    >
      <Image source={{ uri: item.uri }} style={styles.itemImage} />
      <Text style={[styles.itemText, { color: textColor }]}>{item.name}</Text>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={[styles.container, { backgroundColor }]} edges={['top', 'left', 'right']}>
      <StatusBar barStyle={colorScheme === 'dark' ? 'light-content' : 'dark-content'} />
      <CustomHeader
        title={title}
        colorScheme={colorScheme}
        tintColor={tintColor}
        borderColor={borderColor}
        onBackPress={goBack}
        onClosePress={goHome}
      />
      <StyledScrollView className="">
        <View style={styles.contentContainer}>
          <StepIndicator
            currentStep={isGarmentMode ? 1 : 2}
            totalSteps={3}
            stepLabels={['Garment', 'Model', 'Combine']}
            activeColor={tintColor}
          />
          
          {/* Camera window */}
          <View style={[styles.cameraContainer, { borderColor }]}>
            <CameraView style={styles.camera} facing={facing} ref={cameraRef} />
            
            <View style={styles.cameraOverlay}>
              <View style={[styles.cameraGuideFrame, { borderColor: Colors.PRIMARY }]}>
                {isGarmentMode ? (
                  <Ionicons name="shirt-outline" size={48} color="rgba(225, 78, 105,0.7)" />
                ) : (
                  <Ionicons name="person-outline" size={48} color="rgba(225, 78, 105,0.7)" />
                )}
              </View>
            </View>
            
            <TouchableOpacity 
              style={[styles.toggleCameraButton, { backgroundColor: Colors.PRIMARY }]} 
              onPress={toggleCameraFacing}
            >
              <Ionicons name="camera-reverse" size={24} color="#fff" />
            </TouchableOpacity>
          </View>
          
          <Text style={[styles.instruction, { color: secondaryTextColor }]}>
            {instruction}
          </Text>
          
          {/* Gallery, Camera button */}
          <View style={styles.buttonContainer}>
            <TouchableOpacity 
              style={[styles.actionButton, { borderColor }]} 
              onPress={pickImage}
            >
              <Ionicons name="image" size={20} color={tintColor} />
            </TouchableOpacity>
            
            <TouchableOpacity style={styles.captureButton} onPress={takePicture}>
              <View style={[styles.captureButtonOuter, { borderColor: tintColor }]}>
                <View style={[styles.captureButtonInner, { backgroundColor: tintColor }]} />
              </View>
            </TouchableOpacity>
            
            <TouchableOpacity 
              style={[styles.actionButton, { borderColor }]} 
              onPress={() => setModalVisible(true)}
            >
              <Ionicons 
                name={isGarmentMode ? "shirt" : "person"} 
                size={20} 
                color={tintColor} 
              />
            </TouchableOpacity>
          </View>
        </View>
        
        <Modal 
          animationType="slide" 
          transparent={true} 
          visible={modalVisible} 
          onRequestClose={() => setModalVisible(false)}
        >
          <TouchableWithoutFeedback onPress={() => setModalVisible(false)}>
            <View style={styles.modalOverlay}>
              <BlurView intensity={50} style={styles.blurOverlay}>
                <TouchableWithoutFeedback>
                  <View style={[styles.modalContainer, { backgroundColor: cardColor }]}>
                    <View style={[styles.modalHandle, { backgroundColor: colorScheme === 'dark' ? '#444' : '#ddd' }]} />
                    
                    <Text style={[styles.modalTitle, { color: textColor }]}>
                      {isGarmentMode ? 'My Clothes Collection' : 'My Models'}
                    </Text>
                    
                    <FlatList
                      data={isGarmentMode ? mockGarments : mockModels}
                      renderItem={renderItem}
                      keyExtractor={(item) => item.id}
                      style={styles.itemList}
                      horizontal
                      showsHorizontalScrollIndicator={false}
                      contentContainerStyle={styles.itemListContent}
                    />
                    
                    <TouchableOpacity 
                      style={[styles.closeButton, { backgroundColor: tintColor }]} 
                      onPress={() => setModalVisible(false)}
                    >
                      <Text style={styles.closeButtonText}>Close</Text>
                    </TouchableOpacity>
                  </View>
                </TouchableWithoutFeedback>
              </BlurView>
            </View>
          </TouchableWithoutFeedback>
        </Modal>
      </StyledScrollView>
    </SafeAreaView>
  );
};

// Updated Custom Header Component with back arrow and close button
type CustomHeaderProps = {
  title: string;
  colorScheme: string | null | undefined;
  tintColor: string;
  borderColor: string;
  onBackPress: () => void;
  onClosePress: () => void;
};

const CustomHeader = ({ title, colorScheme, tintColor, borderColor, onBackPress, onClosePress }: CustomHeaderProps) => {
  const backgroundColor = colorScheme === 'dark' ? '#1e1e1e' : '#fff';
  const textColor = colorScheme === 'dark' ? '#fff' : '#333';

  return (
    <View style={[styles.header, { backgroundColor, borderBottomColor: borderColor }]}>
      <TouchableOpacity style={styles.headerButton} onPress={onBackPress}>
        <Ionicons name="arrow-back" size={24} color={tintColor} />
      </TouchableOpacity>
      
      <Text style={[styles.headerTitle, { color: textColor }]}>{title}</Text>
      
      <TouchableOpacity style={styles.headerButton} onPress={onClosePress}>
        <Ionicons name="close" size={24} color={tintColor} />
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  stepIndicator: {

  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 50,
    width: '100%',
    paddingHorizontal: 10,
    justifyContent: 'space-between',
    borderBottomWidth: 1,
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
    flex: 1,
  },
  headerButton: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  contentContainer: {
    flex: 1,
    paddingHorizontal: 20,
    paddingBottom: 30,

  },
  permissionContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 30,
  },
  permissionIcon: {
    marginBottom: 20,
  },
  permissionTitle: {
    fontSize: 22,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: 12,
  },
  permissionDescription: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 30,
    lineHeight: 22,
  },
  cameraContainer: {
    width: '100%',
    height: '100%',
    borderRadius: 20,
    overflow: 'hidden',
    marginVertical: 20,
    position: 'relative',
    borderWidth: 1,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  camera: {
    flex: 1,
  },
  cameraOverlay: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: 'center',
    alignItems: 'center',
  },
  cameraGuideFrame: {
    width: 200,
    height: 200,
    borderWidth: 2,
    borderRadius: 10,
    borderStyle: 'dashed',
    justifyContent: 'center',
    alignItems: 'center',
  },
  toggleCameraButton: {
    position: 'absolute',
    bottom: 15,
    right: 15,
    borderRadius: 30,
    padding: 10,
  },
  instruction: {
    fontSize: 14,
    textAlign: 'center',
    marginBottom: 20,
    lineHeight: 20,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 10,
    paddingHorizontal: 10,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 10,
    paddingHorizontal: 15,
    borderRadius: 30,
    backgroundColor: 'transparent',
    borderWidth: 1,
    elevation: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  actionButtonText: {
    fontSize: 12,
    fontWeight: '600',
    marginLeft: 8,
  },
  captureButton: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  captureButtonOuter: {
    width: 70,
    height: 70,
    borderRadius: 35,
    borderWidth: 5,
    justifyContent: 'center',
    alignItems: 'center',
  },
  captureButtonInner: {
    width: 54,
    height: 54,
    borderRadius: 27,
  },
  permissionButton: {
    paddingVertical: 15,
    paddingHorizontal: 30,
    borderRadius: 30,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  buttonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
  },
  blurOverlay: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  modalContainer: {
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    padding: 25,
    paddingTop: 15,
    minHeight: '60%',
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -3 },
    shadowOpacity: 0.2,
    shadowRadius: 5,
  },
  modalHandle: {
    width: 40,
    height: 5,
    borderRadius: 3,
    alignSelf: 'center',
    marginBottom: 20,
  },
  modalTitle: {
    fontSize: 22,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  itemList: {
    flex: 1,
    marginBottom: 20,
  },
  itemListContent: {
    paddingVertical: 10,
    paddingHorizontal: 5,
  },
  item: {
    marginRight: 15,
    alignItems: 'center',
    borderRadius: 12,
    padding: 10,
    borderWidth: 1,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  itemImage: {
    width: 100,
    height: 100,
    borderRadius: 8,
  },
  itemText: {
    fontSize: 14,
    marginTop: 8,
    fontWeight: '500',
  },
  closeButton: {
    paddingVertical: 15,
    borderRadius: 30,
    marginTop: 10,
    alignSelf: 'center',
    width: '80%',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 3,
  },
  closeButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
    textAlign: 'center',
  },
});

export default CaptureScreen;