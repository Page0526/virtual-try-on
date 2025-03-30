import React, { useState, useEffect, useRef } from 'react';
import { View, Text, Pressable, TextInput, Image, ScrollView, Platform, Dimensions, Animated, TouchableWithoutFeedback } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import * as ImagePicker from 'expo-image-picker';
import { styled } from 'nativewind';
import { MaterialIcons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';

const StyledView = styled(View);
const StyledText = styled(Text);
const StyledPressable = styled(Pressable);
const StyledTextInput = styled(TextInput);
const StyledImage = styled(Image);
const StyledScrollView = styled(ScrollView);

// Create Closet Modal Component
interface CreateClosetModalProps {
  visible: boolean;
  onClose: () => void;
  onCreateCloset: (data: { image: string | null; type: string }) => void;
}

const CreateClosetModal = ({ visible, onClose, onCreateCloset }: CreateClosetModalProps) => {
  const [closetImage, setClosetImage] = useState<string | null>(null);
  const [closetType, setClosetType] = useState('clothing');
  const { width, height } = Dimensions.get('window');
  
  // Animation values
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const slideAnim = useRef(new Animated.Value(height)).current;
  
  useEffect(() => {
    if (visible) {
      // Animate in
      Animated.parallel([
        Animated.timing(fadeAnim, {
          toValue: 1,
          duration: 300,
          useNativeDriver: true,
        }),
        Animated.timing(slideAnim, {
          toValue: 0,
          duration: 300,
          useNativeDriver: true,
        }),
      ]).start();
    } else {
      // Animate out
      Animated.parallel([
        Animated.timing(fadeAnim, {
          toValue: 0,
          duration: 250,
          useNativeDriver: true,
        }),
        Animated.timing(slideAnim, {
          toValue: height,
          duration: 250,
          useNativeDriver: true,
        }),
      ]).start();
    }
  }, [visible, fadeAnim, slideAnim, height]);

  const handleBackdropPress = () => {
    onClose();
  };

  const handleContentPress = (e: any) => {
    // Prevent closing when pressing on modal content
    e.stopPropagation();
  };

  const pickImage = async () => {
    const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();
    
    if (permissionResult.granted === false) {
      alert('Permission to access camera roll is required!');
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      aspect: [1, 1],
      quality: 1,
    });

    if (!result.canceled) {
      setClosetImage(result.assets[0].uri);
    }
  };

  if (!visible) return null;

  return (
    <Animated.View 
      style={[
        { 
          position: 'absolute', 
          left: 0, 
          top: 0, 
          width: width, 
          height: height,
          backgroundColor: 'rgba(0,0,0,0.5)',
          opacity: fadeAnim,
        },
      ]}
    >
      <TouchableWithoutFeedback onPress={handleBackdropPress}>
        <View style={{ flex: 1, justifyContent: 'flex-end', marginBottom: 25}}>
          <TouchableWithoutFeedback onPress={handleContentPress}>
            <Animated.View 
              style={[
                {
                  backgroundColor: 'white',
                  borderTopLeftRadius: 24,
                  borderTopRightRadius: 24,
                  padding: 24,
                  shadowColor: "#000",
                  shadowOffset: { width: 0, height: -3 },
                  shadowOpacity: 0.1,
                  shadowRadius: 6,
                  elevation: 5,
                  transform: [{ translateY: slideAnim }],
                  height: height * 0.7,
                },
              ]}
            >
              <StyledView className="items-center mb-2">
                <StyledView className="w-16 h-1 bg-gray-300 rounded-full" />
              </StyledView>

              <StyledView className="flex-row justify-between items-center mb-6">
                <StyledText className="text-xl font-bold">Create New Closet</StyledText>
                <StyledPressable onPress={onClose} className="p-1">
                  <MaterialIcons name="close" size={24} color="#666" />
                </StyledPressable>
              </StyledView>
              
              <StyledScrollView className="flex-1">
                <StyledView className="mb-4">
                  <StyledText className="text-gray-700 font-medium mb-1">Name</StyledText>
                  <StyledTextInput
                    placeholder="Enter closet name"
                    className="bg-gray-100 px-4 py-3 rounded-lg border border-gray-200"
                  />
                </StyledView>
                
                {/* Type Selection */}
                <StyledView className="mb-4">
                  <StyledText className="text-gray-700 font-medium mb-2">Type</StyledText>
                  <StyledView className="flex-row bg-gray-100 rounded-lg overflow-hidden border border-gray-200">
                  <StyledPressable 
                    onPress={() => setClosetType('user')}
                    className="flex-1 py-3 px-4"
                    style={{ backgroundColor: closetType === 'user' ? Colors.PRIMARY : 'transparent' }}
                  >
                    <StyledText 
                      className="text-center font-medium"
                      style={{ color: closetType === 'user' ? '#FFFFFF' : '#4A4A4A' }}
                    >
                      User Image
                    </StyledText>
                  </StyledPressable>

                  <StyledPressable 
                    onPress={() => setClosetType('clothing')}
                    className="flex-1 py-3 px-4"
                    style={{ backgroundColor: closetType === 'clothing' ? Colors.PRIMARY : 'transparent' }}
                  >
                    <StyledText 
                      className="text-center font-medium"
                      style={{ color: closetType === 'clothing' ? '#FFFFFF' : '#4A4A4A' }}
                    >
                      Clothing
                    </StyledText>
                  </StyledPressable>
                  </StyledView>
                </StyledView>

                <StyledView className="mb-6">
                  <StyledText className="text-gray-700 font-medium mb-2">
                    {closetType === 'user' ? 'Your Photo' : 'Clothing Image'}
                  </StyledText>
                  <StyledPressable
                    onPress={pickImage}
                    className="bg-gray-100 rounded-lg p-4 items-center justify-center border border-dashed border-gray-300"
                    style={{ height: 150 }}
                  >
                    {closetImage ? (
                      <StyledImage
                        source={{ uri: closetImage }}
                        className="w-full h-full rounded-lg"
                        resizeMode="cover"
                      />
                    ) : (
                      <StyledView className="items-center justify-center">
                        <MaterialIcons 
                          name={closetType === 'user' ? 'person-add' : 'add-photo-alternate'} 
                          size={40} 
                          color="#9ca3af" 
                        />
                        <StyledText className="text-gray-500 mt-2">
                          {closetType === 'user' ? 'Tap to add your photo' : 'Tap to add clothing image'}
                        </StyledText>
                      </StyledView>
                    )}
                  </StyledPressable>
                </StyledView>

                <StyledView className="flex-row justify-end space-x-3 mb-4">
                  {/* <StyledPressable
                    onPress={onClose}
                    className="bg-gray-200 rounded-lg py-3 px-5"
                  >
                    <StyledText className="font-medium">Cancel</StyledText>
                  </StyledPressable> */}
                  
                  <StyledPressable
                    onPress={() => {
                      onCreateCloset({ image: closetImage, type: closetType });
                      setClosetImage(null);
                    }}
                    className="rounded-lg py-3 px-5 shadow-sm"
                    style={{backgroundColor: Colors.PRIMARY}}
                  >
                    <StyledText className="text-white font-medium">Create</StyledText>
                  </StyledPressable>
                </StyledView>
              </StyledScrollView>
            </Animated.View>
          </TouchableWithoutFeedback>
        </View>
      </TouchableWithoutFeedback>
    </Animated.View>
  );
};

interface ClosetItem {
  id: string;
  name: string;
  description: string;
  image: string;
}

interface OutfitItem {
  id: string;
  name: string;
  occasion: string;
  items: number;
  color: string;
}

const VirtualClosetScreen = () => {
  const [activeTab, setActiveTab] = useState('Closet');
  const [searchQuery, setSearchQuery] = useState('');
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [closetItems, setClosetItems] = useState<ClosetItem[]>([
    {
      id: '1',
      name: 'My Adidas Shoes',
      description: 'This is my favorite pair of shoes',
      image: 'https://bizweb.dktcdn.net/thumb/large/100/424/874/products/z6171338962971-b0c416a77fbc5087938a95c26b487a43.jpg?v=1735390179417'
    },
    {
      id: '2',
      name: 'Sweatshirt - size small',
      description: 'This is my birthday present',
      image: 'https://i.ebayimg.com/images/g/4y8AAOSwv9hm9L5-/s-l1200.jpg'
    }
  ]);
  
  // Add outfit items with a different structure
  const [outfitItems, setOutfitItems] = useState<OutfitItem[]>([
    {
      id: '1',
      name: 'Summer Casual',
      occasion: 'Everyday',
      items: 4,
      color: '#4A90E2'
    },
    {
      id: '2',
      name: 'Formal Meeting',
      occasion: 'Business',
      items: 3,
      color: '#50E3C2'
    },
    {
      id: '3',
      name: 'Night Out',
      occasion: 'Party',
      items: 5,
      color: '#9013FE'
    }
  ]);

  const handleCreateCloset = (closetData: any) => {
    // Here you would typically save the new closet data
    console.log('Creating closet with data:', closetData);
    setShowCreateModal(false);
  };

  return (
    <StyledView className="flex-1 bg-white pt-12 px-4">
      <StatusBar style="dark" />

      {/* Enhanced Header */}
      <StyledView className="mb-6">
        <StyledView className="flex-row justify-center items-center">
          <StyledView className="h-0.5 w-10 mr-4 rounded-full" style={{backgroundColor: Colors.PRIMARY}} />
          <StyledText className="text-2xl font-bold tracking-wider text-center">
            VIRTUAL <StyledText className="text" style={{color: Colors.PRIMARY}}>CLOSET</StyledText>
          </StyledText>
          <StyledView className="h-0.5 w-10 ml-4 rounded-full" style={{backgroundColor: Colors.PRIMARY}}/>
        </StyledView>
        {/* <StyledView className="items-center mt-1">
          <StyledView className="h-0.5 bg-gray-200 w-20 rounded-full" />
        </StyledView> */}
      </StyledView>

      {/* Tabs */}
      <StyledView className="flex-row mb-6 bg-gray-100 rounded-full p-1 mx-4">
      <StyledPressable
        onPress={() => setActiveTab('Closet')}
        className="flex-1 py-2 rounded-full"
        style={{ backgroundColor: activeTab === 'Closet' ? Colors.PRIMARY : 'transparent' }} 
      >
        <StyledText
          className="text-center font-medium"
          style={{ color: activeTab === 'Closet' ? '#FFFFFF' : '#4A4A4A' }}
        >
          Closet
        </StyledText>
      </StyledPressable>

      <StyledPressable
        onPress={() => setActiveTab('Outfit')}
        className="flex-1 py-2 rounded-full"
        style={{ backgroundColor: activeTab === 'Outfit' ? Colors.PRIMARY : 'transparent' }} 
      >
        <StyledText
          className="text-center font-medium"
          style={{ color: activeTab === 'Outfit' ? '#FFFFFF' : '#4A4A4A' }} 
        >
          Outfit
        </StyledText>
      </StyledPressable>

      </StyledView>

      {/* Search Bar */}
      <StyledView className="mx-4 mb-4 relative">
        <StyledView className="flex-row items-center bg-gray-100 rounded-lg px-3">
          <MaterialIcons name="search" size={24} color="#9ca3af" />
          <StyledTextInput
            placeholder={activeTab === 'Closet' ? "Search for clothes..." : "Search for outfits..."}
            value={searchQuery}
            onChangeText={setSearchQuery}
            className="bg-gray-100 px-2 py-3 flex-1"
          />
          {searchQuery.length > 0 && (
            <Pressable onPress={() => setSearchQuery('')}>
              <MaterialIcons name="close" size={20} color="#9ca3af" />
            </Pressable>
          )}
        </StyledView>
      </StyledView>

      {/* Conditional Content Based on Active Tab */}
      {activeTab === 'Closet' ? (
        /* Closet Items and Create Button */
        <StyledScrollView className="flex-1">
          {closetItems.map((item) => (
            <StyledView key={item.id} className="mb-4 mx-4">
              <StyledView className="flex-row">
                <StyledImage 
                  source={{ uri: item.image }} 
                  className="w-16 h-16 rounded-lg mr-4"
                  resizeMode="cover"
                />
                <StyledView className="flex-1 justify-center">
                  <StyledText className="font-semibold text-base">{item.name}</StyledText>
                  <StyledText className="text-gray-500 text-sm mt-1">{item.description}</StyledText>
                </StyledView>
              </StyledView>
            </StyledView>
          ))}
          
          {/* Create Closet Button - Only shown in Closet tab */}
          <StyledView className="items-center my-6 mb-10">
            <StyledPressable
              onPress={() => setShowCreateModal(true)}
              className="rounded-full py-3 px-8 shadow-md flex-row items-center"
              style = {{backgroundColor: '#e14e69'}}
            >
              <MaterialIcons name="add" size={18} color="white" style={{marginRight: 4}} />
              <StyledText className="text-white font-medium">Create a closet</StyledText>
            </StyledPressable>
          </StyledView>
        </StyledScrollView>
      ) : (
        /* Outfit Items - Different layout and no Create button */
        <StyledScrollView className="flex-1">
          {outfitItems.map((outfit) => (
            <StyledView key={outfit.id} className="mb-4 mx-4 bg-white rounded-xl shadow-sm p-4 border border-gray-100">
              <StyledView className="flex-row items-center">
                <StyledView 
                  style={{ backgroundColor: outfit.color }} 
                  className="w-12 h-12 rounded-full mr-4 items-center justify-center"
                >
                  <MaterialIcons name="style" size={24} color="white" />
                </StyledView>
                <StyledView className="flex-1">
                  <StyledText className="font-bold text-base">{outfit.name}</StyledText>
                  <StyledView className="flex-row items-center mt-1">
                    <MaterialIcons name="event" size={14} color="#9ca3af" style={{marginRight: 4}} />
                    <StyledText className="text-gray-500 text-xs">{outfit.occasion}</StyledText>
                    <StyledView className="w-1 h-1 bg-gray-300 rounded-full mx-2" />
                    <MaterialIcons name="checkroom" size={14} color="#9ca3af" style={{marginRight: 4}} />
                    <StyledText className="text-gray-500 text-xs">{outfit.items} items</StyledText>
                  </StyledView>
                </StyledView>
                <MaterialIcons name="chevron-right" size={24} color="#9ca3af" />
              </StyledView>
            </StyledView>
          ))}
          
          {/* Empty bottom space */}
          <StyledView className="h-10" />
        </StyledScrollView>
      )}

      {/* Render the Create Closet Modal as a separate component */}
      <CreateClosetModal 
        visible={showCreateModal}
        onClose={() => setShowCreateModal(false)}
        onCreateCloset={handleCreateCloset}
      />
    </StyledView>
  );
};

export default VirtualClosetScreen;