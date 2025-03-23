import {View, Text, Image, TextInput} from 'react-native'
import React from 'react'
import { useUser } from '@clerk/clerk-expo';
import { Colors } from 'react-native/Libraries/NewAppScreen';
import EvilIcons from '@expo/vector-icons/EvilIcons';
import { Dimensions } from 'react-native';

const { width, height } = Dimensions.get('window');


export default function Header() {

    const {user}=useUser();

    return (
        <View style={{
            paddingHorizontal: '5%',
            height: 0.3 * height,
            display: 'flex',
            flexDirection: 'column',
            gap: 10
        }}>
            {/* User profile bar */}
            <View style={
                {
                    display:'flex',
                    height: '28%',
                    flexDirection: 'row',
                    alignItems:'center',
                    justifyContent: 'space-between',
                }
            }>
                <View style={{
                    marginLeft: '5%',
                    marginTop: '12%',
                }}>
                    <Text>Welcome,</Text>
                    <Text style={{
                        fontSize: 19,
                        color: Colors.PRIMARY
                    }}>{user?.fullName}</Text>
                </View>
                <Image 
                // source={{uri:user?.imageUrl}}
                    source={require('@/assets/images/background.png')}
                    style={{
                        width: 45,
                        height: 45,
                        borderRadius: 99,
                        marginRight: '5%',
                        padding: 0,
                    }}
                />
            </View>
            {/* Search bar */}
            <View style={{
                display:'flex',
                flexDirection:'row',
                gap: 4,
                alignItems:'center',
                backgroundColor:'#EFEFF0',
                borderRadius: 10,
                paddingLeft: 10,
                // height: 50,
                overflow: 'hidden',
            }}>
                <EvilIcons name="search" size={24} color="rgba(60, 60, 67, 0.3)" />
                {/* NOTE: Add Search Engine */}
                <TextInput 
                    placeholder='Search...'
                    placeholderTextColor="rgba(60, 60, 67, 0.3)"
                    style={{
                        flex: 1,
                        height: '100%',
                        textAlignVertical: 'center',
                        paddingVertical: 10,
                    }}
                />
            </View>
        </View>
    )
}
