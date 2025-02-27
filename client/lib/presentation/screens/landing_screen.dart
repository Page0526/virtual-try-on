import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/business_logic/blocs/auth/auth_bloc.dart';
import 'package:myapp/business_logic/blocs/auth/auth_event.dart';
import 'package:myapp/business_logic/blocs/auth/auth_state.dart';
import 'package:myapp/data/models/item.dart';
import 'package:myapp/presentation/screens/smart_outfit_screen.dart';
import 'package:myapp/presentation/screens/wardrobe_screen.dart';
import 'login_screen.dart';
import 'try_on_screen.dart'; 

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trang chủ")),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chào mừng, bạn đã đăng nhập!", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                    child: Text("Đăng xuất"),
                  ),
                  SizedBox(height: 20),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bạn chưa đăng nhập!", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Đăng nhập"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TryOnScreen()),
                      );
                    },
                    child: Text("Thử trang phục"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SmartOutfitScreen(
                            wardrobeItems: [Item(id: '1', name: 'Quần jeans', type: 'jeans', imageUrl: '')],
                          ),
                        ),
                      );
                    },
                    child: Text('Phòng Phối Đồ Thông Minh'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WardrobeScreen()),
                      );
                    },
                    child: const Text('Tủ Quần Áo Số'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}