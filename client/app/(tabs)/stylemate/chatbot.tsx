import React, { useState, useRef, useEffect } from 'react';
import { 
  View, 
  Text, 
  TextInput, 
  TouchableOpacity, 
  SafeAreaView, 
  KeyboardAvoidingView, 
  Platform, 
  StatusBar,
  useWindowDimensions,
  Animated,
  ScrollView,
  FlatList,
  TouchableWithoutFeedback,
  Keyboard,
  KeyboardEvent,
  Image,
  Alert
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import * as ImagePicker from 'expo-image-picker';
import { agentService } from '../../../services/api';

type Message = {
  id: string;
  text: string;
  sentByMe: boolean;
  imageUrl?: string; // Add optional imageUrl property
};

type ChatSession = {
  id: string;
  title: string;
  date: string;
};

export default function ChatScreen() {
  const [inputText, setInputText] = useState('');
  const [messages, setMessages] = useState<Message[]>([]);
  const [isSidebarOpen, setSidebarOpen] = useState(false);
  const [isTyping, setIsTyping] = useState(false);
  const [selectedImage, setSelectedImage] = useState<string | null>(null);
  const sidebarAnimation = useRef(new Animated.Value(0)).current;
  const insets = useSafeAreaInsets();
  const { width } = useWindowDimensions();
  const isTablet = width > 768;
  const inputRef = useRef<TextInput>(null);
  const scrollViewRef = useRef<ScrollView>(null);
  const [keyboardHeight, setKeyboardHeight] = useState(0);
  const [keyboardVisible, setKeyboardVisible] = useState(false);
  const TAB_BAR_HEIGHT = 85; // Height of the tab bar from _layout.tsx
  
  // Sample chat history
  const [chatHistory] = useState<ChatSession[]>([
    { id: '1', title: 'Summer Outfit Ideas', date: 'Today' },
    { id: '2', title: 'Formal Wear Suggestions', date: 'Yesterday' },
    { id: '3', title: 'Casual Friday Outfit', date: '3 days ago' },
    { id: '4', title: 'Beach Vacation Packing', date: 'Last week' },
    { id: '5', title: 'Winter Collection Preview', date: '2 weeks ago' },
  ]);

  const toggleSidebar = () => {
    const toValue = isSidebarOpen ? 0 : 1;
    Animated.spring(sidebarAnimation, {
      toValue,
      useNativeDriver: true,
      friction: 8,
    }).start();
    setSidebarOpen(!isSidebarOpen);
  };

  const sidebarTranslateX = sidebarAnimation.interpolate({
    inputRange: [0, 1],
    outputRange: [300, 0],
  });

  // Send message to the agent API
  const sendMessage = async () => {
    if (inputText.trim() === '') return;
    
    // Create and display user message
    const userMessage: Message = {
      id: Date.now().toString(),
      text: inputText,
      sentByMe: true,
      ...(selectedImage && { imageUrl: selectedImage }),
    };
    
    setMessages(prev => [...prev, userMessage]);
    
    // Store the message text before clearing it
    const messageText = inputText;
    const imageUri = selectedImage;
    
    setInputText('');
    setSelectedImage(null);
    
    // Dismiss keyboard on send
    dismissKeyboard();
    
    // Show the typing indicator
    setIsTyping(true);
    
    try {
      // Send message to agent based on whether there's an image
      let response;
      
      if (imageUri) {
        response = await agentService.sendMessageWithImage(messageText, imageUri);
      } else {
        response = await agentService.sendTextMessage(messageText);
      }
      
      // Handle successful response
      if (response && response.success) {
        const botResponse: Message = {
          id: Date.now().toString(),
          text: response.response,
          sentByMe: false,
        };
        
        setMessages(prevMessages => [...prevMessages, botResponse]);
      } else {
        throw new Error("Invalid response from agent");
      }
    } catch (error: any) {
      console.error("Error sending message to agent:", error);
      // Show error message
      const errorMessage: Message = {
        id: Date.now().toString(),
        text: "Sorry, I'm having trouble responding right now. Please try again later.",
        sentByMe: false,
      };
      setMessages(prevMessages => [...prevMessages, errorMessage]);
    } finally {
      setIsTyping(false);
    }
  };

  const resetConversation = async () => {
    try {
      setIsTyping(true);
      const response = await agentService.resetConversation();
      
      if (response && response.success) {
        setMessages([]);
        
        // Show welcome message
        const welcomeMessage: Message = {
          id: Date.now().toString(),
          text: "Hi! I'm StyleMate, your personal fashion assistant. How can I help you today?",
          sentByMe: false,
        };
        setMessages([welcomeMessage]);
      }
    } catch (error) {
      console.error("Error resetting conversation:", error);
      Alert.alert("Error", "Failed to reset conversation. Please try again.");
    } finally {
      setIsTyping(false);
    }
  };

  const pickImage = async () => {
    // Request permission
    const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();
    
    if (permissionResult.granted === false) {
      Alert.alert("Permission Required", "You need to allow access to your photos to upload images");
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      aspect: [4, 3],
      quality: 0.8,
    });
    
    if (!result.canceled && result.assets && result.assets.length > 0) {
      const uri = result.assets[0].uri;
      setSelectedImage(uri);
    }
  };

  const selectChatSession = (session: ChatSession) => {
    // In a real app, you would load the messages for this session
    console.log(`Selected chat session: ${session.title}`);
    toggleSidebar();
  };

  const dismissKeyboard = () => {
    Keyboard.dismiss();
  };

  // Scroll to bottom when new messages arrive
  useEffect(() => {
    if (messages.length > 0) {
      setTimeout(() => {
        scrollViewRef.current?.scrollToEnd({ animated: true });
      }, 100);
    }
  }, [messages]);

  // Enhanced keyboard event handling
  useEffect(() => {
    const keyboardWillShowListener = Keyboard.addListener(
      Platform.OS === 'ios' ? 'keyboardWillShow' : 'keyboardDidShow',
      (e: KeyboardEvent) => {
        setKeyboardHeight(e.endCoordinates.height);
        setKeyboardVisible(true);
        scrollViewRef.current?.scrollToEnd({ animated: true });
      }
    );
    
    const keyboardWillHideListener = Keyboard.addListener(
      Platform.OS === 'ios' ? 'keyboardWillHide' : 'keyboardDidHide',
      () => {
        setKeyboardHeight(0);
        setKeyboardVisible(false);
      }
    );

    return () => {
      keyboardWillShowListener.remove();
      keyboardWillHideListener.remove();
    };
  }, []);

  // Display welcome message on first load
  useEffect(() => {
    const welcomeMessage: Message = {
      id: Date.now().toString(),
      text: "Hi! I'm StyleMate, your personal fashion assistant. How can I help you today?",
      sentByMe: false,
    };
    setMessages([welcomeMessage]);
  }, []);

  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView className="flex-1 bg-white">
        {/* Header */}
        <View 
          className={`px-6 flex-row flex-1 items-center justify-between ${isTablet ? 'h-16' : 'h-14'}`}
          style={{
            shadowColor: '#000',
            shadowOffset: { width: 0, height: 2 },
            shadowOpacity: 0.15,
            shadowRadius: 4,
            elevation: 5,
            backgroundColor: '#FDFDFD',
            borderBottomWidth: 1,
            borderBottomColor: '#F0F0F0',
            paddingTop: 20,
            maxHeight: 90
          }}
        >
          
          <View className="flex-row items-center">
            <Ionicons name="hardware-chip-outline" size={isTablet ? 24 : 20} color="#E14E69" style={{ marginRight: 8 }} />
            <Text 
              className={`text-black font-bold ${isTablet ? 'text-2xl' : 'text-xl'}`}
              style={{ letterSpacing: 0.5, color: '#333' }}
            >
              STYLEMATE
            </Text>
          </View>
          <View className="flex-row items-center">
            <TouchableOpacity 
              className={`w-10 h-10 items-center justify-center rounded-full bg-gray-200 mr-2`}
              onPress={toggleSidebar}
            >
              <Ionicons name="time-outline" size={isTablet ? 24 : 20} color="#222" />
            </TouchableOpacity>
            <TouchableOpacity 
              className={`w-10 h-10 items-center justify-center rounded-full bg-gray-200`}
              onPress={resetConversation}
            >
              <Ionicons name="refresh-outline" size={isTablet ? 24 : 20} color="#222" />
            </TouchableOpacity>
          </View>
        </View>
        
        {/* Main content and messages area */}
        <View className="flex-1">
          {/* TouchableWithoutFeedback to dismiss keyboard when tapping outside input */}
          <TouchableWithoutFeedback onPress={dismissKeyboard}>
            <View className="flex-1">
              {/* Messages area with padding to account for floating input */}
              <View 
                className={`flex-1 ${isTablet ? 'px-8 pt-4' : 'px-4 pt-3'}`}
                style={{ 
                  marginTop: -4,
                  paddingBottom: keyboardVisible ? 80 : TAB_BAR_HEIGHT + 50, // Increased padding to account for floating input
                }}
              >
                {messages.length === 0 ? (
                  <View className="flex-1 items-center justify-center opacity-70">
                    <Ionicons name="chatbubble-ellipses-outline" size={isTablet ? 70 : 56} color="#DDD" />
                    <Text className="text-gray-400 mt-4 text-center px-8">
                      Start a conversation with your StyleMate for fashion advice and recommendations
                    </Text>
                  </View>
                ) : (
                  <ScrollView
                    ref={scrollViewRef}
                    className="flex-1"
                    contentContainerStyle={{ 
                      flexGrow: 1, 
                      justifyContent: 'flex-end',
                      paddingBottom: 16
                    }}
                    keyboardShouldPersistTaps="handled"
                    showsVerticalScrollIndicator={false}
                  >
                    {messages.map((message) => (
                      <View 
                        key={message.id}
                        className={`my-2 ${isTablet ? 'max-w-md' : 'max-w-xs'} ${
                          message.sentByMe 
                            ? 'self-end bg-blue-500 rounded-tl-2xl rounded-tr-2xl rounded-bl-2xl' 
                            : 'self-start bg-gray-200 rounded-tl-2xl rounded-tr-2xl rounded-br-2xl'
                        }`}
                        style={{
                          shadowColor: '#000',
                          shadowOffset: { width: 0, height: 1 },
                          shadowOpacity: 0.08,
                          shadowRadius: 2,
                          elevation: 2,
                          alignSelf: message.sentByMe ? 'flex-end' : 'flex-start',
                        }}
                      >
                        <Text className={`p-3 ${isTablet ? 'text-base' : ''} ${
                          message.sentByMe ? 'text-white' : 'text-black'
                        }`}>
                          {message.text}
                        </Text>
                        {message.imageUrl && (
                          <Image 
                            source={{ uri: message.imageUrl }} 
                            style={{ width: 200, height: 200, borderRadius: 10, marginTop: 5, marginBottom: 20, alignSelf: 'center' }} 
                          />
                        )}
                      </View>
                    ))}
                    
                    {/* Typing indicator */}
                    {isTyping && (
                      <View 
                        className="my-1.5 self-start bg-gray-100 rounded-tl-2xl rounded-tr-2xl rounded-br-2xl px-4 py-2"
                      >
                        <Text className="text-gray-500">Generating...</Text>
                      </View>
                    )}
                  </ScrollView>
                )}
              </View>
            </View>
          </TouchableWithoutFeedback>
        </View>
        
        {/* Floating input over the tab bar */}
        <KeyboardAvoidingView
          behavior={Platform.OS === 'ios' ? 'position' : 'height'}
          keyboardVerticalOffset={Platform.OS === 'ios' ? 10 : 0}
          style={{
            position: 'absolute',
            bottom: TAB_BAR_HEIGHT, // Position right at the top of the tab bar
            left: 0,
            right: 0,
            zIndex: 100,
          }}
        >
          <View 
            style={{
              paddingHorizontal: isTablet ? 32 : 16,
              paddingBottom: 4, // Small padding to provide separation from tab bar
            }}
          >
            <View 
              className="rounded-2xl border border-gray-100 bg-white"
              style={{
                shadowColor: '#000',
                shadowOffset: { width: 0, height: 2 },
                shadowOpacity: 0.1,
                shadowRadius: 4,
                elevation: 5,
              }}
            >
              <View 
                className={`flex-row items-center gap-3 ${isTablet ? 'py-3 px-3' : 'py-2 px-3'}`}
              >
                <TouchableOpacity className="" onPress={pickImage}>
                  <Ionicons name="image-outline" size={isTablet ? 28 : 24} color="#666" />
                </TouchableOpacity>
                
                <View className={`relative flex-1 flex-row ${isTablet ? 'h-12' : 'h-11'}`}>
                  <TouchableWithoutFeedback>
                    <View 
                      className={`bg-gray-100 rounded-xl pl-2 w-[100%]`}
                      style={{
                        shadowColor: '#000',
                        shadowOffset: { width: 0, height: 1 },
                        shadowOpacity: 0.05,
                        shadowRadius: 1,
                        elevation: 1,
                      }}
                    >
                      <TextInput
                        ref={inputRef}
                        value={inputText}
                        onChangeText={setInputText}
                        placeholder={selectedImage ? "Add a caption to your image..." : "Ask anything about fashion..."}
                        placeholderTextColor="#A0A0A0"
                        className={`text-black ${isTablet ? 'text-base py-1' : 'py-0.5'}`}
                        multiline={false}
                        autoCapitalize="sentences"
                        autoCorrect={true}
                        blurOnSubmit={false}
                        returnKeyType="send"
                        spellCheck={true}
                        onSubmitEditing={sendMessage}
                        enablesReturnKeyAutomatically={true}
                      />
                    </View>
                  </TouchableWithoutFeedback>
                </View>
                
                {/* Show selected image indicator */}
                {selectedImage && (
                  <View className="absolute bottom-11 left-2 flex-row items-center bg-gray-100 rounded-md px-2 py-1">
                    <Ionicons name="image" size={16} color="#666" />
                    <Text className="text-xs text-gray-600 ml-1">Image selected</Text>
                    <TouchableOpacity onPress={() => setSelectedImage(null)} className="ml-1">
                      <Ionicons name="close-circle" size={16} color="#666" />
                    </TouchableOpacity>
                  </View>
                )}
                
                <TouchableOpacity 
                    onPress={sendMessage}
                    className="items-center justify-center"
                    style={{
                      backgroundColor: '#E14E69',
                      borderRadius: 20,
                      width: 36,
                      height: 36,
                      shadowColor: '#000',
                      shadowOffset: { width: 0, height: 1 },
                      shadowOpacity: 0.1,
                      shadowRadius: 1,
                      elevation: 2,
                    }}
                  >
                    <Ionicons name="paper-plane" size={isTablet ? 20 : 18} color="white" />
                  </TouchableOpacity>
              </View>
            </View>
          </View>
        </KeyboardAvoidingView>

        {/* Chat History Sidebar */}
        <Animated.View 
          style={{
            position: 'absolute',
            top: 0,
            right: 0,
            bottom: 0,
            width: isTablet ? 350 : 280,
            backgroundColor: '#fff',
            zIndex: 1000,
            transform: [{ translateX: sidebarTranslateX }],
            shadowColor: '#000',
            shadowOffset: { width: -2, height: 0 },
            shadowOpacity: 0.15,
            shadowRadius: 5,
            elevation: 10,
            paddingTop: insets.top || 40,
          }}
        >
          <View className="flex-row items-center justify-between px-6 py-4 border-b border-gray-200">
            <Text className="text-lg font-bold text-gray-800">Chat History</Text>
            <TouchableOpacity onPress={toggleSidebar} className="p-2">
              <Ionicons name="close" size={24} color="#333" />
            </TouchableOpacity>
          </View>
          
          <FlatList
            data={chatHistory}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => (
              <TouchableOpacity 
                onPress={() => selectChatSession(item)}
                className="px-6 py-4 border-b border-gray-100 active:bg-gray-50"
              >
                <Text className="text-base font-medium text-gray-800">{item.title}</Text>
                <Text className="text-sm text-gray-500 mt-1">{item.date}</Text>
              </TouchableOpacity>
            )}
            contentContainerStyle={{ paddingBottom: 40 }}
          />
          
          <TouchableOpacity 
            className="absolute bottom-0 left-0 right-0 py-4 bg-blue-500 items-center"
            style={{ paddingBottom: Math.max(insets.bottom, 16) }}
          >
            <Text className="text-white font-medium">New Chat</Text>
          </TouchableOpacity>
        </Animated.View>
        
        {/* Backdrop overlay when sidebar is open */}
        {isSidebarOpen && (
          <TouchableOpacity
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              backgroundColor: 'rgba(0,0,0,0.3)',
              zIndex: 999,
            }}
            activeOpacity={1}
            onPress={toggleSidebar}
          />
        )}
      </SafeAreaView>
    </>
  );
}