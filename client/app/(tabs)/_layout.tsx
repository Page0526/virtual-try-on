import {View, Text} from 'react-native'
import React from 'react'
import { Tabs } from 'expo-router'
import Feather from '@expo/vector-icons/Feather';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import Ionicons from '@expo/vector-icons/Ionicons';
import {Colors} from './../../constants/Colors' 

export default function TabLayout() {
    return (
        <Tabs screenOptions={{
            headerShown: false,
            tabBarActiveTintColor: Colors.PRIMARY,
            tabBarStyle: {
                position: 'absolute',
                bottom: 0, // Placed at the bottom of the screen
                marginHorizontal: 0, // Removed side margins
                backgroundColor: '#ffffff',
                borderRadius: 25, // All corners rounded
                borderColor: 'rgba(0, 0, 0, 0.3)',
                borderWidth: 0.5,
                shadowColor: '#000',
                shadowOffset: { width: 0, height: 10 },
                shadowOpacity: 0.1,
                shadowRadius: 8,
                elevation: 10,
                height: 85, // Increased height
                paddingBottom: 12,
                width: '100%', // Full width
            },
            tabBarLabelStyle: {
                fontSize: 12,
                marginBottom: 8, // Increased to move label up
            },
            tabBarIconStyle: {
                marginTop: 8, // Increased to move icons up
            }
            }}>
            <Tabs.Screen 
                name='shop/home'
                options={{
                    tabBarLabel: 'Home',
                    tabBarIcon: ({color})=><Ionicons name="home-outline" className="w-5 h-5 md:w-6 md:h-6 lg:w-7 lg:h-7" size={24} color={color} />
                }}
            />
            <Tabs.Screen 
                name='shop/cart' 
                options={{
                    tabBarLabel: 'Cart',
                    tabBarIcon: ({color})=><Feather name="shopping-bag" className="w-5 h-5 md:w-6 md:h-6 lg:w-7 lg:h-7" size={24} color={color} />
                }}/>
            <Tabs.Screen 
                name='fitting_room/input_src'
                options={{
                    tabBarLabel: 'Fitting Room',
                    tabBarIcon: ({color})=><MaterialCommunityIcons name="wardrobe-outline" className="w-5 h-5 md:w-6 md:h-6 lg:w-7 lg:h-7" size={24} color={color} />
                }}/>
            <Tabs.Screen 
                name='stylemate/chatbot' 
                options={{
                    tabBarLabel: 'StyleMate',
                    tabBarIcon: ({color})=><MaterialCommunityIcons name="robot-love-outline" className="w-5 h-5 md:w-6 md:h-6 lg:w-7 lg:h-7" size={24} color={color} />
                }}/>
            <Tabs.Screen 
                name='fitting_room/closet'
                options={{
                    tabBarLabel: 'Closet',
                    tabBarIcon: ({color})=><Ionicons name="heart-circle-outline" className="w-5 h-5 md:w-6 md:h-6 lg:w-7 lg:h-7" size={24} color={color} />
                }}/>
        </Tabs>
    )
}