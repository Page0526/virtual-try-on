import {View, Text, Image, TextInput} from 'react-native'
import React from 'react'
import { useUser } from '@clerk/clerk-expo';
import { Colors } from 'react-native/Libraries/NewAppScreen';
import Feather from '@expo/vector-icons/Feather';
import Ionicons from '@expo/vector-icons/Ionicons';
 
export default function Header() {

    const {user}=useUser();

    return (
        <View style={{
            padding: 20,
            paddingTop: 40
            
        }}>
            <View style={
                {
                    display:'flex',
                    flexDirection: 'row',
                    alignItems:'center',
                    gap:10
                }
            }>
                <Image source={{uri:user?.imageUrl}}
                    style={{
                        width: 45,
                        height: 45,
                        borderRadius: 99
                    }}
                />
                <View>
                    <Text>Welcome,</Text>
                    <Text style={{
                        fontSize: 19,
                        color: Colors.PRIMARY
                    }}>{user?.fullName}</Text>
                </View>
            </View>
            <View style={{
                display:'flex',
                flexDirection:'row',
                gap: 10,
                alignItems:'center',
                backgroundColor:'#3C3C43',
                padding: 10,
                marginVertical: 10,
                marginTop: 15,
                borderRadius: 8
            }}>
                {/* Search bar */}
                <Feather name="search" size={24} color="black" />
                <TextInput placeholder='Search...'/>
            </View>
        </View>
    )
}
