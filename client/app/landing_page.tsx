import React from 'react';
import { View, Text, ImageBackground, TouchableOpacity, Platform, StatusBar } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { styled } from 'nativewind';
import { LinearGradient } from 'expo-linear-gradient';
import { useRouter } from 'expo-router';
import { useWindowDimensions } from 'react-native';

const StyledView = styled(View);
const StyledText = styled(Text);
const StyledImageBackground = styled(ImageBackground);
const StyledTouchableOpacity = styled(TouchableOpacity);

const LandingScreen: React.FC = () => {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const { width } = useWindowDimensions();
  const fontSize = width * 0.09;
  
  return (
    <StyledView className="flex-1 bg-white">
      <StatusBar barStyle="light-content" />
      <StyledImageBackground
      source={require('@/assets/images/background.png')}
      className="flex-1 w-full h-[70%]"
      >
           <LinearGradient
            colors={['rgba(240, 91, 110, 0.3)', 'rgba(240, 91, 110, 0.3)']}
            className = "absolute w-full h-[70%]"
          />
        <StyledView className={`flex-1 px-[5%] justify-end pb-[10%]`} style={{paddingTop: insets.top}}>
          <StyledView>
            <StyledText className="text-white text-[8vw] font-semibold mb-[1%]">WHAT TO WEAR</StyledText>
          </StyledView>
          
          <StyledView className='mb-[5%]'>
              <StyledText style={{ fontSize, fontWeight: 'bold', color: 'black' }}>NOW SO MUCH</StyledText>
              <StyledText style={{ fontSize, fontWeight: 'bold', color: 'black' }}>EASIER 😍</StyledText>
          </StyledView>
          
          <StyledView className="mb-[5%]">
            <StyledTouchableOpacity 
              className="bg-[#f05b6e] py-[3vw] rounded-[15px] items-center"
              onPress={() => router.replace('/(tabs)/shop/home')}
            >
              <StyledText className="text-white text-[7vw] font-semibold">Get started</StyledText>
            </StyledTouchableOpacity>
          </StyledView>
        </StyledView>
      </StyledImageBackground>
    </StyledView>
  );
};

export default LandingScreen;
