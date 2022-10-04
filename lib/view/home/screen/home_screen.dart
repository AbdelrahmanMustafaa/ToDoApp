import 'package:firebasetest/model/grateful_model/grateful_model.dart';
import 'package:firebasetest/model/mode_model/mode_model.dart';
import 'package:firebasetest/view/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/tasks_model/task_model.dart';
import '../cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).getTasks();
    print('==========================================================');
    print('initState');
    getShared();
    print (previousDays);
  }

  @override
  void dispose() {
    BlocProvider.of<HomeCubit>(context).valueController.dispose();
    BlocProvider.of<HomeCubit>(context).stateController.dispose();
    BlocProvider.of<HomeCubit>(context).gratefulController.dispose();
    super.dispose();
  }

  List<String> previousDays = [];

  Future<List> getShared() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    previousDays = sharedPreferences.getKeys().toList();
    return previousDays;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
          return Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  ListTile(
                    leading: const Icon(Icons.report_problem),
                    title: const Text('Feelings report'),
                    onTap: () {
                      // show dialog
                    },
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(previousDays[index]),
                            onTap: () {},
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: previousDays.length),
                  ),
                ],
              ),
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: const IconThemeData(size: 22),
              backgroundColor: Colors.teal,
              visible: true,
              curve: Curves.bounceIn,
              children: [
                // task button
                SpeedDialChild(
                    child: const Icon(Icons.assignment_turned_in,
                        color: Colors.white),
                    backgroundColor: Colors.teal,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Add ToDo"),
                                content: TextFormField(
                                  controller: cubit.valueController,
                                  decoration: const InputDecoration(
                                    labelText: "Task",
                                  ),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      cubit
                                          .addTask(
                                        TaskModel(
                                          value: cubit.valueController.text,
                                          state: true.toString(),
                                        ),
                                      )
                                          .then((value) {
                                        cubit.getTasks();
                                        cubit.valueController.clear();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.teal,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.red,
                                  )
                                ],
                              ));
                    },
                    label: 'Add Task',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.0),
                    labelBackgroundColor: Colors.teal),
                // grateful button
                SpeedDialChild(
                    child: Image.asset('Images/hands.png'),
                    backgroundColor: Colors.teal,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                    "What are you grateful for to day "),
                                content: TextFormField(
                                  controller: cubit.gratefulController,
                                  decoration: const InputDecoration(
                                    labelText: "Grateful",
                                  ),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      cubit
                                          .addGrateful(
                                        GratefulModel(
                                          value: cubit.gratefulController.text,
                                        ),
                                      )
                                          .then((value) {
                                        cubit.getGrateful();
                                        cubit.gratefulController.clear();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.teal,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.red,
                                  )
                                ],
                              ));
                    },
                    label: 'Grateful',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.0),
                    labelBackgroundColor: Colors.teal)
              ],
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: const Text('ToDo List'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: Colors.black,
                              ),
                              height: 150,
                              width: 150,
                              child: Image(
                                image: AssetImage(cubit.mainEmotion),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    cubit.changeEmoji(cubit.happyEmoji);
                                    cubit.putModeToShared(cubit.happyEmoji);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black,
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: Image(
                                      image: AssetImage(cubit.happyEmoji),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    cubit.putModeToShared(cubit.neutralEmoji);
                                    cubit.changeEmoji(cubit.neutralEmoji);

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black,
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: Image(
                                      image: AssetImage(cubit.neutralEmoji),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  highlightColor: Colors.white,
                                  onTap: () {
                                    cubit.changeEmoji(cubit.sadEmoji);
                                    cubit.putModeToShared(cubit.sadEmoji);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black,
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: Image(
                                      image: AssetImage(cubit.sadEmoji),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: cubit.listGrateful.isNotEmpty
                              ? FutureBuilder(
                                  future: cubit.getGrateful(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? AnimationLimiter(
                                            child: ListView.separated(
                                                itemBuilder: (context, index) =>
                                                    AnimationConfiguration
                                                        .staggeredList(
                                                      position: index,
                                                      duration: const Duration(
                                                          milliseconds: 1500),
                                                      child: SlideAnimation(
                                                        child: ScaleAnimation(
                                                          child: Dismissible(
                                                            key: UniqueKey(),
                                                            resizeDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                            background:
                                                                Container(
                                                              color: Colors.red,
                                                              child: const Text(
                                                                'Delete',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                            ),
                                                            direction:
                                                                DismissDirection
                                                                    .startToEnd,
                                                            onDismissed: (d) {
                                                              cubit.deleteGrateful(
                                                                  cubit
                                                                      .listGrateful[
                                                                          index]
                                                                      .id!
                                                                      .toInt());
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      '${index + 1}-',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      '${cubit.listGrateful[index].value}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog(
                                                                                    title: const Text("Update Grateful"),
                                                                                    content: TextFormField(
                                                                                      controller: cubit.gratefulController,
                                                                                      decoration: const InputDecoration(
                                                                                        labelText: "what's new",
                                                                                      ),
                                                                                    ),
                                                                                    actions: <Widget>[
                                                                                      MaterialButton(
                                                                                        onPressed: () {
                                                                                          cubit
                                                                                              .updateGrateful(GratefulModel(
                                                                                            value: cubit.gratefulController.text,
                                                                                          ))
                                                                                              .then((value) {
                                                                                            cubit.gratefulController.clear();
                                                                                            Navigator.of(context).pop();
                                                                                          });
                                                                                        },
                                                                                        child: const Text(
                                                                                          'Update',
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ),
                                                                                        color: Colors.teal,
                                                                                      ),
                                                                                      MaterialButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: const Text(
                                                                                          'Cancel',
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ),
                                                                                        color: Colors.red,
                                                                                      )
                                                                                    ],
                                                                                  );
                                                                                });
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.edit,
                                                                            color:
                                                                                Colors.teal,
                                                                          )),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            cubit.deleteGrateful(cubit.listGrateful[index].id!.toInt());
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.red,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Divider(),
                                                itemCount:
                                                    cubit.listGrateful.length),
                                          )
                                        : snapshot.hasError
                                            ? const Center(
                                                child: Text(
                                                    'There are some errors'),
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator());
                                  })
                              : Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child:
                                              Image.asset('Images/hands.png')),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'There are no Grateful please add some',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                    future: cubit.getTasks(),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: snapshot.hasData
                            ? AnimationLimiter(
                                child: ListView.separated(
                                    itemBuilder: (context, index) =>
                                        AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          child: SlideAnimation(
                                            child: ScaleAnimation(
                                              child: Dismissible(
                                                key: UniqueKey(),
                                                resizeDuration: const Duration(
                                                    milliseconds: 1000),
                                                background: Container(
                                                  color: Colors.red,
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                ),
                                                direction:
                                                    DismissDirection.startToEnd,
                                                onDismissed: (d) {
                                                  cubit.deleteTask(cubit
                                                      .tasksList[index].id!
                                                      .toInt());
                                                },
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${index + 1}-',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Checkbox(
                                                            activeColor:
                                                                Colors.teal,
                                                            value: cubit
                                                                        .tasksList[
                                                                            index]
                                                                        .state
                                                                        .toString() ==
                                                                    'false'
                                                                ? true
                                                                : false,
                                                            onChanged: (value) {
                                                              cubit.updateTask(
                                                                TaskModel(
                                                                  id: cubit
                                                                      .tasksList[
                                                                          index]
                                                                      .id,
                                                                  value: cubit
                                                                      .tasksList[
                                                                          index]
                                                                      .value,
                                                                  state: cubit.tasksList[index].state ==
                                                                          'false'
                                                                      ? true
                                                                          .toString()
                                                                      : false
                                                                          .toString(),
                                                                ),
                                                              );
                                                            }),
                                                        Text(
                                                          '${cubit.tasksList[index].value}',
                                                          style: TextStyle(
                                                            decoration: cubit
                                                                        .tasksList[
                                                                            index]
                                                                        .state ==
                                                                    "false"
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            "Update Task"),
                                                                        content:
                                                                            TextFormField(
                                                                          controller:
                                                                              cubit.valueController,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText:
                                                                                "what's new",
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          MaterialButton(
                                                                            onPressed:
                                                                                () {
                                                                              cubit
                                                                                  .updateTask(
                                                                                TaskModel(
                                                                                  id: cubit.tasksList[index].id,
                                                                                  value: cubit.valueController.text,
                                                                                  state: cubit.tasksList[index].state,
                                                                                ),
                                                                              )
                                                                                  .then((value) {
                                                                                cubit.valueController.clear();
                                                                                Navigator.of(context).pop();
                                                                              });
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Update',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          MaterialButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                            color:
                                                                                Colors.red,
                                                                          )
                                                                        ],
                                                                      );
                                                                    });
                                                              },
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.teal,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                cubit.deleteTask(cubit
                                                                    .tasksList[
                                                                        index]
                                                                    .id!
                                                                    .toInt());
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemCount: cubit.tasksList.length),
                              )
                            : snapshot.hasError
                                ? const Center(
                                    child: Text('There are some errors'),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
