import React, { useEffect, useState } from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity, ActivityIndicator, StatusBar } from 'react-native';
import * as FileSystem from 'expo-file-system';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { useColorScheme } from '@/hooks/useColorScheme';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { SafeAreaView } from 'react-native-safe-area-context';
import { BlurView } from 'expo-blur';

// Define orange-red theme colors - matching the CaptureScreen theme
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

const ConfirmPhotoScreen = () => {
  const router = useRouter();
  const { type, photoUri } = useLocalSearchParams();
  const { setGarmentUri, setModelUri } = useFittingContext();
  const colorScheme = useColorScheme();
  const [uriValid, setUriValid] = useState(true);
  const [loading, setLoading] = useState(true);
  const [imageLoaded, setImageLoaded] = useState(false);

  const isGarmentMode = type === 'garment';
  const isDark = colorScheme === 'dark';
  
  // Use orange-red theme colors
  const primaryColor = isDark ? orangeRedTheme.dark.tint : orangeRedTheme.light.tint;
  const backgroundColor = isDark ? orangeRedTheme.dark.background : orangeRedTheme.light.background;
  const textColor = isDark ? orangeRedTheme.dark.text : orangeRedTheme.light.text;
  const secondaryTextColor = isDark ? orangeRedTheme.dark.secondaryText : orangeRedTheme.light.secondaryText;
  const cardBackgroundColor = isDark ? orangeRedTheme.dark.card : orangeRedTheme.light.card;
  const borderColor = isDark ? orangeRedTheme.dark.border : orangeRedTheme.light.border;

  // Process the photoUri parameter
  const uri = typeof photoUri === 'string' ? photoUri : undefined;

  // Validate that the file exists
  useEffect(() => {
    const validateUri = async () => {
      if (!uri) {
        console.warn('No photoUri provided, redirecting to capture screen');
        setUriValid(false);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture',
          params: { type },
        });
        return;
      }

      try {
        const exists = await FileSystem.getInfoAsync(uri);
        if (!exists.exists) {
          console.warn('Photo file does not exist, redirecting to capture screen');
          setUriValid(false);
          router.push({
            pathname: '/(tabs)/virtual-fitting/screens/capture',
            params: { type },
          });
        } else {
          setLoading(false);
        }
      } catch (error) {
        console.error('Error checking file:', error);
        setUriValid(false);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture',
          params: { type },
        });
      }
    };

    validateUri();
  }, [uri, router, type]);

  const confirmPhoto = () => {
    if (uri) {
      if (isGarmentMode) {
        setGarmentUri(uri);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture',
          params: { type: 'model' },
        });
      } else {
        setModelUri(uri);
        router.push('/(tabs)/virtual-fitting/screens/combine');
      }
    }
  };

  const retakePhoto = () => {
    router.push({
      pathname: '/(tabs)/virtual-fitting/screens/capture',
      params: { type },
    });
  };

  if (!uriValid) {
    return null;
  }

  const contentTitle = 'FITTING ROOM';
  const instructionText = isGarmentMode 
    ? 'Is this garment photo clear and well-lit?'
    : 'Check if your pose and lighting look good';

  return (
    <SafeAreaView style={[styles.container, { backgroundColor }]} edges={['top', 'left', 'right']}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />
      
      <LinearGradient
        colors={isDark ? ['#0f172a', '#1e293b'] : ['#f8fafc', '#ffffff']}
        style={styles.gradientBackground}
      />
      
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity 
          style={styles.backButton} 
          onPress={retakePhoto}
        >
          <Ionicons name="arrow-back" size={24} color={primaryColor} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle, { color: textColor }]}>
          {contentTitle}
        </Text>
        <View style={styles.placeholderButton} />
      </View>

      {/* Preview Container */}
      <View style={styles.previewContainer}>
        <View style={[styles.previewCard, { backgroundColor: cardBackgroundColor, borderColor }]}>
          {loading && !imageLoaded ? (
            <View style={styles.loadingContainer}>
              <ActivityIndicator size="large" color={primaryColor} />
              <Text style={[styles.loadingText, { color: secondaryTextColor }]}>
                Loading image...
              </Text>
            </View>
          ) : null}
          
          <Image
            source={{ uri }}
            style={styles.previewImage}
            onLoad={() => setImageLoaded(true)}
            onError={(error) => {
              console.error('Error loading image:', error.nativeEvent.error);
              setUriValid(false);
            }}
          />
          
          <BlurView 
            intensity={80} 
            tint={isDark ? 'dark' : 'light'}
            style={styles.typeIndicatorContainer}
          >
            <View style={styles.typeIndicator}>
              <Ionicons 
                name={isGarmentMode ? "shirt" : "person"} 
                size={18} 
                color={primaryColor} 
              />
              <Text style={[styles.typeIndicatorText, { color: textColor }]}>
                {isGarmentMode ? 'Garment' : 'Model'}
              </Text>
            </View>
          </BlurView>
        </View>
      </View>

      {/* Instruction */}
      <BlurView 
        intensity={isDark ? 20 : 50} 
        tint={isDark ? 'dark' : 'light'} 
        style={styles.instructionWrapper}
      >
        <View style={[styles.instructionContainer, { 
          backgroundColor: isDark ? 'rgba(30, 30, 30, 0.8)' : 'rgba(255, 255, 255, 0.8)' 
        }]}>
          <Ionicons 
            name="information-circle" 
            size={22} 
            color={primaryColor} 
            style={styles.instructionIcon}
          />
          <Text style={[styles.instruction, { color: textColor }]}>
            {instructionText}
          </Text>
        </View>
      </BlurView>

      {/* Action Buttons */}
      <View style={styles.actionContainer}>
        <TouchableOpacity 
          style={[styles.actionButton, styles.secondaryButton, { 
            borderColor: primaryColor,
            backgroundColor: isDark ? 'rgba(255, 69, 0, 0.1)' : 'rgba(255, 69, 0, 0.05)'
          }]} 
          onPress={retakePhoto}
        >
          <Ionicons name="camera-outline" size={22} color={primaryColor} style={styles.buttonIcon} />
          <Text style={[styles.buttonText, { color: primaryColor }]}>RETAKE</Text>
        </TouchableOpacity>
        
        <TouchableOpacity 
          style={[styles.actionButton, styles.primaryButton, { backgroundColor: primaryColor }]} 
          onPress={confirmPhoto}
        >
          <Ionicons name="checkmark" size={22} color="#fff" style={styles.buttonIcon} />
          <Text style={[styles.buttonText, styles.primaryButtonText]}>
            {isGarmentMode ? 'NEXT' : 'CONTINUE'}
          </Text>
        </TouchableOpacity>
      </View>
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
    paddingHorizontal: 20,
    paddingVertical: 15,
  },
  backButton: {
    padding: 8,
  },
  placeholderButton: {
    width: 40,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    textAlign: 'center',
    letterSpacing: 1,
  },
  previewContainer: {
    flex: 1,
    marginHorizontal: 20,
    marginTop: 10,
    marginBottom: 20,
  },
  previewCard: {
    flex: 1,
    borderRadius: 24,
    overflow: 'hidden',
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.25,
    shadowRadius: 10,
    borderWidth: 1,
  },
  loadingContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 10,
    backgroundColor: 'rgba(0,0,0,0.1)',
  },
  loadingText: {
    marginTop: 10,
    fontSize: 14,
  },
  previewImage: {
    flex: 1,
    resizeMode: 'cover',
  },
  typeIndicatorContainer: {
    position: 'absolute',
    top: 16,
    right: 16,
    borderRadius: 20,
    overflow: 'hidden',
  },
  typeIndicator: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 8,
    paddingHorizontal: 16,
  },
  typeIndicatorText: {
    marginLeft: 8,
    fontWeight: '600',
    fontSize: 14,
  },
  instructionWrapper: {
    marginHorizontal: 30,
    borderRadius: 16,
    overflow: 'hidden',
    marginBottom: 20,
  },
  instructionContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 14,
    paddingHorizontal: 20,
    borderRadius: 16,
  },
  instructionIcon: {
    marginRight: 10,
  },
  instruction: {
    fontSize: 15,
    textAlign: 'center',
    lineHeight: 22,
  },
  actionContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    marginBottom: 24,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 14,
    borderRadius: 14,
    flex: 1,
    marginHorizontal: 8,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.15,
    shadowRadius: 3,
  },
  buttonIcon: {
    marginRight: 8,
  },
  buttonText: {
    fontSize: 14,
    fontWeight: '600',
    letterSpacing: 0.5,
  },
  secondaryButton: {
    backgroundColor: 'transparent',
    borderWidth: 1,
  },
  primaryButton: {
    backgroundColor: '#FF4500',
  },
  primaryButtonText: {
    color: '#fff',
  },
  progressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingBottom: 30,
    paddingHorizontal: 20,
  },
  progressStep: {
    alignItems: 'center',
  },
  progressDot: {
    width: 14,
    height: 14,
    borderRadius: 7,
    marginBottom: 8,
    borderWidth: 2,
  },
  progressLine: {
    height: 3,
    width: 45,
    marginHorizontal: 5,
  },
  progressText: {
    fontSize: 12,
    letterSpacing: 0.3,
  },
});

export default ConfirmPhotoScreen;