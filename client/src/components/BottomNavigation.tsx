import React from 'react';
import { View, Text, TouchableOpacity, Platform } from 'react-native';
import { styled } from 'nativewind';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter, usePathname, RelativePathString } from 'expo-router';

// Styled components
const StyledView = styled(View);
const StyledText = styled(Text);
const StyledTouchableOpacity = styled(TouchableOpacity);

type NavItem = {
  name: string;
  route: string;
  activeIcon: React.ReactNode;
  inactiveIcon: React.ReactNode;
};

const BottomNavigation: React.FC = () => {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const pathname = usePathname();

  const navItems: NavItem[] = [
    {
      name: 'Home',
      route: '/home',
      activeIcon: <Ionicons name="home" size={26} color="#E75D6F" style={{fontWeight: 'bold'}}/>,
      inactiveIcon: <Ionicons name="home-outline" size={26} color="#666" style={{fontWeight: 'bold'}}/>
    },
    {
      name: 'Cart',
      route: '/shop/cart',
      activeIcon: <Ionicons name="cart" size={26} color="#E75D6F" style={{fontWeight: 'bold'}}/>,
      inactiveIcon: <Ionicons name="cart-outline" size={26} color="#666" style={{fontWeight: 'bold'}}/>
    },
    {
      name: 'Fitting Room',
      route: '/fitting_room',
      activeIcon: <Ionicons name="shirt" size={26} color="#E75D6F" style={{fontWeight: 'bold'}}/>,
      inactiveIcon: <Ionicons name="shirt-outline" size={26} color="#666" style={{fontWeight: 'bold'}}/>
    },
    {
      name: 'StyleMate',
      route: '/stylemate',
      activeIcon: <Ionicons name="color-wand" size={26} color="#E75D6F" style={{fontWeight: 'bold'}}/>,
      inactiveIcon: <Ionicons name="color-wand-outline" size={26} color="#666" style={{fontWeight: 'bold'}}/>
    },
    {
      name: 'Closet',
      route: '/closet',
      activeIcon: <Ionicons name="heart" size={26} color="#E75D6F" style={{fontWeight: 'bold'}}/>,
      inactiveIcon: <Ionicons name="heart-outline" size={26} color="#666" style={{fontWeight: 'bold'}}/>
    }
  ];

  const isActive = (route: string) => {
    // Handle special cases
    if (route === '/home' && pathname === '/') {
      return true;
    }

    // Check if current path starts with the route
    return pathname.startsWith(route);
  };

  const navigateTo = (route: string) => {
    router.push(route as RelativePathString);
  };

  const shadowStyle = Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: -3 },
      shadowOpacity: 0.1,
      shadowRadius: 3,
    },
    android: {
      elevation: 5,
    },
  });

  return (
    <StyledView
      className="flex-row justify-around items-center bg-white border-t border-gray-200 absolute bottom-0 left-0 right-0 z-50"
      style={{
        paddingBottom: insets.bottom ? insets.bottom : 8, paddingTop: 12, position: 'absolute', bottom: 0, left: 0, right: 0, width: '100%', flexDirection: 'row', borderTopLeftRadius: 20,
        borderTopRightRadius: 20,
        borderTopWidth: 1,
        borderColor: '#e5e7eb',
        ...shadowStyle
      }}
    >

      {navItems.map((item) => (
        <StyledTouchableOpacity
          key={item.name}
          className="items-center"
          onPress={() => navigateTo(item.route)}
          style={{ flex: 1 }}
        >
          {isActive(item.route) ? item.activeIcon : item.inactiveIcon}
          <StyledText
            className={`${isActive(item.route) ? 'text-[#E75D6F]' : 'text-gray-500'}`}
            style={{ fontSize: 10 }}
          >
            {item.name}
          </StyledText>
        </StyledTouchableOpacity>
      ))}
    </StyledView>
  );
};

export default BottomNavigation;