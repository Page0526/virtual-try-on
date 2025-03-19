import React from 'react';
import { View, Text, ImageBackground, TouchableOpacity, Platform, StatusBar } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { styled } from 'nativewind';
import { LinearGradient } from 'expo-linear-gradient';

const StyledView = styled(View);
const StyledText = styled(Text);
const StyledImageBackground = styled(ImageBackground);
const StyledTouchableOpacity = styled(TouchableOpacity);

const LandingScreen: React.FC = () => {
  const insets = useSafeAreaInsets();

  return (
    <StyledView className="flex-1 bg-white">
      <StatusBar barStyle="light-content" />
      <StyledImageBackground
      source={require('@/assets/images/background.png')}
      className="flex-1 w-full h-[70%] "
      >
           <LinearGradient
            colors={['rgba(240, 91, 110, 0.3)', 'rgba(240, 91, 110, 0.3)']}
            className = "absolute w-full h-[70%]"
          />



        <StyledView className={`flex-1 px-[5%] justify-end pb-[10%]`} style={{paddingTop: insets.top}}>
          <StyledView className="absolute top-[70%] left-[5%]">
            <StyledText className="text-white text-5xl font-semibold">WHAT TO WEAR</StyledText>
          </StyledView>
          
          <StyledView className="mb-[10%]">
              <StyledText className="text-black text-4xl font-bold leading-[55px]">NOW SO MUCH</StyledText>
              <StyledText className="text-black text-4xl font-bold leading-[55px]">EASIER 😍</StyledText>
          </StyledView>
          
          <StyledView className="mb-[6%]">
            <StyledTouchableOpacity className="bg-[#f05b6e] py-[15px] rounded-lg items-center">
              <StyledText className="text-white text-3xl font-semibold">Get started</StyledText>
            </StyledTouchableOpacity>
          </StyledView>
        </StyledView>
      </StyledImageBackground>
    </StyledView>
  );
};

export default LandingScreen;
