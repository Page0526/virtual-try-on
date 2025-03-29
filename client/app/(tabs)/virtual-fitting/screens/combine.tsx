import React, { useState, useEffect, useRef } from 'react';
import { 
  View, 
  Text, 
  Image, 
  StyleSheet, 
  ActivityIndicator, 
  Dimensions, 
  TouchableOpacity,
  Animated,
  ScrollView,
  Alert // Import Alert
} from 'react-native';
import * as FileSystem from 'expo-file-system';
import { useRouter } from 'expo-router';
import { useFittingContext } from '../context/fitting-context';
import { tryOnService } from '@/services/api'; // Import the API service
import { useColorScheme } from '@/hooks/useColorScheme';
import StepIndicator from '@/components/Fitting-room/StepIndicator';
import { SafeAreaView } from 'react-native-safe-area-context';
import { AntDesign, MaterialIcons, Ionicons, Feather } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import * as Haptics from 'expo-haptics';

const { width, height } = Dimensions.get('window');

// Define orange-red theme colors to match CaptureScreen
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

const CombineScreen = () => {
  const router = useRouter();
  const { garmentUri, modelUri, setResultUri } = useFittingContext();
  const colorScheme = useColorScheme();
  const [loading, setLoading] = useState(false);
  const [urisValid, setUrisValid] = useState(true);
  const [processingStage, setProcessingStage] = useState('');

  // Animation refs
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(0.95)).current;
  const progressAnim = useRef(new Animated.Value(0)).current;
  const mergeAnim = useRef(new Animated.Value(0)).current;

  // Get orange-red theme colors
  const tintColor = colorScheme === 'dark' ? orangeRedTheme.dark.tint : orangeRedTheme.light.tint;
  const backgroundColor = colorScheme === 'dark' ? orangeRedTheme.dark.background : orangeRedTheme.light.background;
  const textColor = colorScheme === 'dark' ? orangeRedTheme.dark.text : orangeRedTheme.light.text;
  const secondaryTextColor = colorScheme === 'dark' ? orangeRedTheme.dark.secondaryText : orangeRedTheme.light.secondaryText;
  const cardColor = colorScheme === 'dark' ? orangeRedTheme.dark.card : orangeRedTheme.light.card;
  const borderColor = colorScheme === 'dark' ? orangeRedTheme.dark.border : orangeRedTheme.light.border;

  // Theme colors
  const colors = {
    background: backgroundColor,
    card: cardColor,
    text: textColor,
    subText: secondaryTextColor,
    primary: orangeRedTheme.primary,
    primaryLight: colorScheme === 'dark' ? 'rgba(255,69,0,0.2)' : 'rgba(255,69,0,0.1)',
    secondary: '#FF6347', // Tomato color
    accent: '#FF7F50', // Coral color
    danger: '#EF4444',
    border: borderColor,
    overlay: colorScheme === 'dark' ? 'rgba(18, 18, 18, 0.8)' : 'rgba(255, 255, 255, 0.9)',
  };

  // Animation sequences
  useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 500,
        useNativeDriver: true,
      }),
      Animated.timing(scaleAnim, {
        toValue: 1,
        duration: 400,
        useNativeDriver: true,
      }),
    ]).start();
  }, []);

  // Merge animation
  const animateMerge = () => {
    Animated.timing(mergeAnim, {
      toValue: 1,
      duration: 1500,
      useNativeDriver: true,
    }).start();
  };

  // Progress animation
  const animateProgress = () => {
    Animated.timing(progressAnim, {
      toValue: 1,
      duration: 2000,
      useNativeDriver: false,
    }).start();
  };

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

  // Validate URIs when screen loads
  useEffect(() => {
    const validateUris = async () => {
      const garmentExists = garmentUri ? await checkFileExists(garmentUri) : false;
      const modelExists = modelUri ? await checkFileExists(modelUri) : false;

      if (!garmentExists || !modelExists) {
        console.warn('One or both URIs are invalid or files do not exist, redirecting...');
        setUrisValid(false);
        router.push({
          pathname: '/(tabs)/virtual-fitting/screens/capture',
          params: { type: !garmentExists ? 'garment' : 'model' },
        });
      }
    };

    validateUris();
  }, [garmentUri, modelUri, router]);

  // Generate the combined image by calling the API
  const generateImage = async () => {
    if (!garmentUri || !modelUri) {
      Alert.alert('Error', 'Garment or model image is missing.');
      return;
    }

    setLoading(true);
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
    animateMerge();
    animateProgress(); // Keep progress animation for visual feedback

    try {
      setProcessingStage('Uploading images...');
      // Call the API service
      const result = await tryOnService.processTryOn(garmentUri, modelUri, {
        // You can pass specific options here if needed, otherwise defaults are used
        garment_des: "Virtual try-on item", 
      });

      setProcessingStage('Processing complete!');

      // Set the result URI from the API response
      if (result && result.result_url) {
        setResultUri(result.result_url);
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
        // Navigate to result screen
        router.push('/(tabs)/virtual-fitting/screens/result');
      } else {
        throw new Error('Invalid API response: Missing result_url');
      }

    } catch (error: any) {
      console.error('Error generating image:', error);
      Alert.alert(
        'Processing Error',
        `Failed to create virtual fitting: ${error.message || 'Please try again.'}`,
        [{ text: 'OK' }]
      );
      // Reset animations or state if needed
      mergeAnim.setValue(0);
      progressAnim.setValue(0);
      setProcessingStage(''); // Clear stage text on error
    } finally {
      setLoading(false);
    }
  };

  if (!urisValid) {
    return null;
  }

  // Merge animation transforms
  const leftTransform = mergeAnim.interpolate({
    inputRange: [0, 0.5, 1],
    outputRange: [0, -width * 0.15, 0]
  });
  
  const rightTransform = mergeAnim.interpolate({
    inputRange: [0, 0.5, 1],
    outputRange: [0, width * 0.15, 0]
  });
  
  // Progress width for the progress bar
  const progressWidth = progressAnim.interpolate({
    inputRange: [0, 1],
    outputRange: ['0%', '100%']
  });

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]} edges={['top', 'left', 'right']}>
      {/* Gradient Background */}
      <LinearGradient
        colors={colorScheme === 'dark' ? ['#121212', '#1e1e1e'] : ['#ffffff', '#fff8f6']}
        style={styles.gradientBackground}
      />

      {/* Header Section - Updated to match CaptureScreen */}
      <View style={[styles.header, { backgroundColor: colors.background, borderBottomColor: colors.border, borderBottomWidth: 1 }]}>
        <TouchableOpacity
          style={styles.headerButton}
          onPress={() => {
            Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
            router.push({
              pathname: '/(tabs)/virtual-fitting/screens/capture',
              params: { type: 'model' },
            });
          }}
        >
          <Ionicons name="arrow-back" size={24} color={colors.primary} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle, { color: colors.text }]}>VIRTUAL FITTING</Text>
        <TouchableOpacity 
          style={styles.headerButton}
          onPress={() => {
            Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
            router.replace('/(tabs)/shop/home');
          }}
        >
          <Ionicons name="close" size={24} color={colors.primary} />
        </TouchableOpacity>
      </View>

      {/* Step Indicator - Update activeColor to match orange-red theme */}
      <StepIndicator
        currentStep={3}
        totalSteps={3}
        stepLabels={['Capture Garment', 'Capture Model', 'Combine Images']}
        activeColor={colors.primary}
      />

      <ScrollView 
        style={styles.scrollContainer}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Section Title */}
        <Animated.View style={{ opacity: fadeAnim, transform: [{ scale: scaleAnim }] }}>
          <Text style={[styles.sectionTitle, { color: colors.text }]}>
            Preview & Combine
          </Text>
          <Text style={[styles.sectionDescription, { color: colors.subText }]}>
            Verify your images before creating your virtual fitting
          </Text>
        </Animated.View>

        {/* Images Container */}
        <View style={styles.imagesContainer}>
          {/* Garment Image */}
          <Animated.View 
            style={[
              styles.imageCard, 
              { 
                backgroundColor: colors.card, 
                borderColor: colors.border,
                transform: [{ translateX: loading ? leftTransform : 0 }]
              }
            ]}
          >
            <View style={styles.imageHeaderRow}>
              <View style={styles.imageHeaderLeft}>
                <MaterialIcons name="checkroom" size={18} color={colors.primary} style={styles.imageTypeIcon} />
                <Text style={[styles.imageLabel, { color: colors.text }]}>Garment</Text>
              </View>
              <MaterialIcons name="check-circle" size={20} color={colors.secondary} />
            </View>
            <View style={[styles.imageWrapper, { borderColor: colors.border }]}>
              <Image
                source={{ uri: garmentUri || '' }}
                style={styles.image}
                onError={(error) => console.error('Error loading garment image:', error.nativeEvent.error)}
              />
              <TouchableOpacity 
                style={[styles.editButton, { backgroundColor: colors.overlay }]}
                onPress={() => {
                  Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
                  router.push({
                    pathname: '/(tabs)/virtual-fitting/screens/capture',
                    params: { type: 'garment' },
                  });
                }}
              >
                <Feather name="edit-2" size={16} color={colors.primary} />
              </TouchableOpacity>
            </View>
          </Animated.View>
          
          {/* Plus Icon or Animation */}
          {loading ? (
            <Animated.View 
              style={[styles.processingIcon, { opacity: fadeAnim }]}
            >
              <ActivityIndicator size="small" color={colors.primary} />
            </Animated.View>
          ) : (
            <Animated.View 
              style={[
                styles.plusIconContainer, 
                { 
                  backgroundColor: colors.primaryLight,
                  opacity: fadeAnim
                }
              ]}
            >
              <AntDesign name="plus" size={20} color={colors.primary} />
            </Animated.View>
          )}
          
          {/* Model Image */}
          <Animated.View 
            style={[
              styles.imageCard, 
              { 
                backgroundColor: colors.card, 
                borderColor: colors.border,
                transform: [{ translateX: loading ? rightTransform : 0 }]
              }
            ]}
          >
            <View style={styles.imageHeaderRow}>
              <View style={styles.imageHeaderLeft}>
                <Ionicons name="person-outline" size={18} color={colors.primary} style={styles.imageTypeIcon} />
                <Text style={[styles.imageLabel, { color: colors.text }]}>Model</Text>
              </View>
              <MaterialIcons name="check-circle" size={20} color={colors.secondary} />
            </View>
            <View style={[styles.imageWrapper, { borderColor: colors.border }]}>
              <Image
                source={{ uri: modelUri || '' }}
                style={styles.image}
                onError={(error) => console.error('Error loading model image:', error.nativeEvent.error)}
              />
              <TouchableOpacity 
                style={[styles.editButton, { backgroundColor: colors.overlay }]}
                onPress={() => {
                  Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
                  router.push({
                    pathname: '/(tabs)/virtual-fitting/screens/capture',
                    params: { type: 'model' },
                  });
                }}
              >
                <Feather name="edit-2" size={16} color={colors.primary} />
              </TouchableOpacity>
            </View>
          </Animated.View>
        </View>

        {/* Image quality checklist */}
        <Animated.View 
          style={[
            styles.qualityCard, 
            { 
              backgroundColor: colors.card, 
              borderColor: colors.border,
              opacity: fadeAnim
            }
          ]}
        >
          <Text style={[styles.qualityTitle, { color: colors.text }]}>
            Image Quality Check
          </Text>
          
          <View style={styles.checklistItem}>
            <View style={[styles.checkIcon, { backgroundColor: colors.secondary + '20' }]}>
              <Feather name="check" size={14} color={colors.secondary} />
            </View>
            <Text style={[styles.checklistText, { color: colors.subText }]}>
              Images properly framed and aligned
            </Text>
          </View>
          
          <View style={styles.checklistItem}>
            <View style={[styles.checkIcon, { backgroundColor: colors.secondary + '20' }]}>
              <Feather name="check" size={14} color={colors.secondary} />
            </View>
            <Text style={[styles.checklistText, { color: colors.subText }]}>
              Adequate lighting for both images
            </Text>
          </View>
          
          <View style={styles.checklistItem}>
            <View style={[styles.checkIcon, { backgroundColor: colors.secondary + '20' }]}>
              <Feather name="check" size={14} color={colors.secondary} />
            </View>
            <Text style={[styles.checklistText, { color: colors.subText }]}>
              Model pose suitable for garment fitting
            </Text>
          </View>
        </Animated.View>

        {/* Action Buttons */}
        <View style={styles.actionSection}>
          <TouchableOpacity
            style={[
              styles.secondaryButton, 
              { 
                borderColor: colors.border,
                backgroundColor: colors.card
              },
              loading && styles.disabledButton
            ]}
            disabled={loading}
            onPress={() => {
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
              router.replace('/(tabs)/shop/home');
            }}
          >
            <Text style={[styles.secondaryButtonText, { color: colors.text }]}>Restart</Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[
              styles.primaryButton, 
              { backgroundColor: colors.primary },
              loading && styles.disabledButton
            ]}
            disabled={loading}
            onPress={() => {
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
              generateImage();
            }}
          >
            <Text style={styles.primaryButtonText}>Create Fitting</Text>
            {!loading && <Feather name="arrow-right" size={18} color="#fff" style={styles.buttonIcon} />}
          </TouchableOpacity>
        </View>
      </ScrollView>

      {/* Loading Overlay */}
      {loading && (
        <View style={[styles.loadingOverlay, { backgroundColor: colors.overlay }]}>
          <View style={[styles.loadingCard, { backgroundColor: colors.card }]}>
            <View style={styles.processingImageContainer}>
              <Image source={{ uri: modelUri ?? '' }} style={styles.processingImage} />
              <View style={[styles.processingOverlay, { backgroundColor: 'rgba(0,0,0,0.5)' }]}>
                <ActivityIndicator size="large" color={colors.primary} />
              </View>
            </View>
            
            <Text style={[styles.loadingText, { color: colors.text }]}>{processingStage}</Text>
            
            <View style={[styles.progressBarContainer, { backgroundColor: colors.border }]}>
              <Animated.View 
                style={[
                  styles.progressBar, 
                  { 
                    backgroundColor: colors.primary,
                    width: progressWidth
                  }
                ]} 
              />
            </View>
            
            <Text style={[styles.loadingSubtext, { color: colors.subText }]}>
              Creating your virtual fitting...
            </Text>
          </View>
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
  scrollContainer: {
    flex: 1,
  },
  scrollContent: {
    paddingHorizontal: 20,
    paddingBottom: 30,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    height: 50,
    paddingHorizontal: 10,
  },
  headerButton: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    letterSpacing: 1,
    textAlign: 'center',
    flex: 1,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    marginTop: 20,
    marginBottom: 6,
  },
  sectionDescription: {
    fontSize: 16,
    marginBottom: 20,
  },
  imagesContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  imageCard: {
    width: width * 0.38,
    borderRadius: 16,
    padding: 12,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    borderWidth: 1,
  },
  imageHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  imageHeaderLeft: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  imageTypeIcon: {
    marginRight: 6,
  },
  imageLabel: {
    fontSize: 15,
    fontWeight: '600',
  },
  imageWrapper: {
    width: '100%',
    height: width * 0.38,
    borderRadius: 12,
    overflow: 'hidden',
    borderWidth: 1,
    position: 'relative',
  },
  image: {
    width: '100%',
    height: '100%',
    resizeMode: 'cover',
  },
  editButton: {
    position: 'absolute',
    bottom: 8,
    right: 8,
    width: 28,
    height: 28,
    borderRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
  },
  plusIconContainer: {
    width: 36,
    height: 36,
    borderRadius: 18,
    justifyContent: 'center',
    alignItems: 'center',
  },
  processingIcon: {
    width: 36,
    height: 36,
    justifyContent: 'center',
    alignItems: 'center',
  },
  qualityCard: {
    padding: 16,
    borderRadius: 16,
    marginBottom: 24,
    borderWidth: 1,
  },
  qualityTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 12,
  },
  checklistItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  checkIcon: {
    width: 22,
    height: 22,
    borderRadius: 11,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 10,
  },
  checklistText: {
    fontSize: 14,
  },
  actionSection: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 8,
  },
  primaryButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 14,
    paddingHorizontal: 24,
    borderRadius: 12,
    flex: 2,
    marginLeft: 12,
  },
  primaryButtonText: {
    color: '#fff',
    fontWeight: '600',
    fontSize: 16,
  },
  secondaryButton: {
    paddingVertical: 14,
    paddingHorizontal: 20,
    borderRadius: 12,
    borderWidth: 1,
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  secondaryButtonText: {
    fontWeight: '500',
    fontSize: 16,
  },
  buttonIcon: {
    marginLeft: 8,
  },
  disabledButton: {
    opacity: 0.6,
  },
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1000,
  },
  loadingCard: {
    padding: 24,
    borderRadius: 20,
    alignItems: 'center',
    width: width * 0.8,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
  },
  processingImageContainer: {
    width: '100%',
    height: width * 0.4,
    borderRadius: 12,
    overflow: 'hidden',
    marginBottom: 20,
    position: 'relative',
  },
  processingImage: {
    width: '100%',
    height: '100%',
    resizeMode: 'cover',
  },
  processingOverlay: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  progressBarContainer: {
    width: '100%',
    height: 6,
    borderRadius: 3,
    marginBottom: 16,
    overflow: 'hidden',
  },
  progressBar: {
    height: '100%',
  },
  loadingSubtext: {
    fontSize: 14,
    textAlign: 'center',
  },
});

export default CombineScreen;
