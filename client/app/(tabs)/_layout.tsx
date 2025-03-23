import {View, Text} from 'react-native'
import React from 'react'
import { Tabs } from 'expo-router'
import Feather from '@expo/vector-icons/Feather';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import Ionicons from '@expo/vector-icons/Ionicons';
import {Colors} from './../../constants/Colors' 
import { StyleSheet } from 'react-native';

export default function TabLayout() {
    return (
        <Tabs screenOptions={{
            headerShown:false,
            tabBarActiveTintColor: Colors.PRIMARY,
            tabBarStyle: styles.tabBar,
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

const styles = StyleSheet.create({
    tabBar: {
        position: 'absolute',
        bottom: -16, // Space from bottom
        backgroundColor: '#ffffff',
        borderRadius: 25,
        borderBottomEndRadius: 0,
        borderColor: 'rgba(0, 0, 0, 0.3)',
        borderWidth: 0.5,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 10 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
        elevation: 10,
        height: 70,
        paddingBottom: 10,
    }
});