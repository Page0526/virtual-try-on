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
            headerShown:false,
            tabBarActiveTintColor: Colors.PRIMARY
            }}>
            <Tabs.Screen 
                name='shop/home'
                options={{
                    tabBarLabel: 'Home',
                    tabBarIcon: ({color})=><Ionicons name="home-outline" size={24} color={color} />
                }}
            />
            <Tabs.Screen 
                name='shop/cart' 
                options={{
                    tabBarLabel: 'Cart',
                    tabBarIcon: ({color})=><Feather name="shopping-bag" size={24} color={color} />
                }}/>
            <Tabs.Screen 
                name='fitting_room/input_src'
                options={{
                    tabBarLabel: 'Fitting Room',
                    tabBarIcon: ({color})=><MaterialCommunityIcons name="wardrobe-outline" size={24} color={color} />
                }}/>
            <Tabs.Screen 
                name='stylemate/chatbot' 
                options={{
                    tabBarLabel: 'StyleMate',
                    tabBarIcon: ({color})=><MaterialCommunityIcons name="robot-love-outline" size={24} color={color} />
                }}/>
            <Tabs.Screen 
                name='fitting_room/closet'
                options={
                    {
                        tabBarLabel: 'Closet',
                        tabBarIcon: ({color})=><Ionicons name="heart-circle-outline" size={24} color={color} />
                    }
                }/>
        </Tabs>
    )
}