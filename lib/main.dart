import 'package:exercise1/user/bloc/user_list_bloc.dart';
import 'package:exercise1/user/bloc/user_list_event.dart';
import 'package:exercise1/user/bloc/user_list_state.dart';
import 'package:exercise1/user/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserListBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Add User Sample',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Crud Using BLOC"),
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state is UserListUpdated && state.users.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return buildUserTile(context, state.users[index]);
              },
              itemCount: state.users.length,
            );
          } else {
            return const SizedBox(
              width: double.infinity,
              child: Center(child: Text("No users found")),
            );
          }
        },
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            final id = DateTime.now().millisecondsSinceEpoch.toString();
            showBottomSheet(context, false, id);
          },
          child: const Text("Add User")),
    );
  }

  Widget buildUserTile(BuildContext context, UserModel userModel) {
    return ListTile(
      title: Text(userModel.name),
      subtitle: Text(userModel.email),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            onPressed: () {
              BlocProvider.of<UserListBloc>(context)
                  .add(DeleteUserEvent(user: userModel));
            },
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            )),
        IconButton(
            onPressed: () {
              showBottomSheet(context, true, userModel.id);
            },
            icon: Icon(
              Icons.edit,
              color: Colors.blue,
            ))
      ]),
    );
  }

  void showBottomSheet(BuildContext context, bool isEdit, String id) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          TextEditingController nameController = TextEditingController();
          TextEditingController emailController = TextEditingController();
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              isEdit? Text(
                "Update User" 
              ) : Text("Add User"),
              buildTextField(nameController, "Name"),
              SizedBox(
                height: 6,
              ),
              buildTextField(emailController, "Email"),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          final UserModel model = UserModel(
                              id: id,
                              name: nameController.text,
                              email: emailController.text);
                              if(isEdit){
                                BlocProvider.of<UserListBloc>(context)
                                .add(UpdateUserEvent(user: model));
                              } else {
                                BlocProvider.of<UserListBloc>(context)
                              .add(AddUserEvent(user: model));
                          
                              }
                              Navigator.pop(context);
                        
                        },
                        child: Text("Add User")),
                  )
                ],
              ),
            ]),
          );
        });
  }

  Widget buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(6))),
    );
  }
}
