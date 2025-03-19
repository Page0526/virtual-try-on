import React from 'react';
import { View, Text, ImageBackground, TouchableOpacity, Platform, StatusBar } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { styled } from 'nativewind';

const StyledView = styled(View);
const StyledText = styled(Text);
const StyledImageBackground = styled(ImageBackground);
const StyledTouchableOpacity = styled(TouchableOpacity);

const FashionAppScreen: React.FC = () => {
  const insets = useSafeAreaInsets();

  return (
    <StyledView className="flex-1 bg-white">
      <StatusBar barStyle="light-content" />
      <StyledImageBackground
        source={require('@/assets/images/background.jpg')}
        className="flex-1 w-full h-3/5"
      >
        <StyledView className={`flex-1 px-[5%] justify-end pb-[10%]`} style={{paddingTop: insets.top}}>
          <StyledView className="absolute top-[58%] left-[5%]">
            <StyledText className="text-white text-5xl font-semibold">WHAT TO WEAR</StyledText>
          </StyledView>
          
          <StyledView className="mb-[30%]">
              <StyledText className="text-black text-5xl font-bold leading-[55px]">NOW SO MUCH</StyledText>
              <StyledText className="text-black text-5xl font-bold leading-[55px]">EASIER 😍</StyledText>
          </StyledView>
          
          <StyledView className="mb-[6%]">
            <StyledTouchableOpacity className="bg-[#f05b6e] py-[15px] rounded-lg items-center">
              <StyledText className="text-white text-lg font-semibold">Get started</StyledText>
            </StyledTouchableOpacity>
          </StyledView>
        </StyledView>
      </StyledImageBackground>
    </StyledView>
  );
};

export default FashionAppScreen;
