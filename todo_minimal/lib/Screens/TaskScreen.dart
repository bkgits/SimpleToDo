


import'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:todo_minimal/Models/TaskProvider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 10.0,
        onPressed: (){
          showModalBottomSheet(isScrollControlled:true,context: context, builder: (BuildContext context){
            return TaskCreator(isUpdate:false);
          });
        },
          label: Text('Add Tasks',style:GoogleFonts.montserrat(fontSize: 14.0,fontWeight: FontWeight.w800),

          ),
      icon: Icon(FlutterRemix.add_line),),

      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 150.0,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Text('SimpleDo',style: GoogleFonts.montserrat(fontSize: 25.0,fontWeight: FontWeight.w800,color: Colors.black),),
                  ),
                )
              ),
              Consumer<TaskProvider>(builder: (context,TaskProvider data,child){
               return data.getTasks.length!=0?SliverList(delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: TaskTile(task: data.getTasks[index], index: index),
                 );
               },childCount: data.getTasks.length)):SliverToBoxAdapter(
                 child: Align(alignment:Alignment.centerLeft,child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Text('Add Some Tasks..',style: GoogleFonts.montserrat(fontWeight: FontWeight.w800,fontSize: 14.0,color: Colors.black54),),
                 )),
               );
              })
            ],
          ),
        ),
      ),
    );
  }
}


class TaskTile extends StatelessWidget {
  const TaskTile({Key? key,required this.task,required this.index}) : super(key: key);
  final DocumentSnapshot task;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:(){
          Provider.of<TaskProvider>(context,listen: false).updateComplete(task.id,index,task.data['completed']?false:true);
        },
        onLongPress:(){
          showDialog(context: context, builder:(BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton.icon(onPressed: (){
                      Navigator.pop(context);

                      showModalBottomSheet(isScrollControlled:true,context: context, builder: (BuildContext context){
                        return TaskCreator(isUpdate: true,task: task,index: index,);
                      });
                    }, icon: Icon(FlutterRemix.edit_2_line,color: Colors.black,), label: Text('Edit',style: GoogleFonts.montserrat(fontWeight: FontWeight.w800,fontSize: 20.0,color: Colors.black),)),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton.icon(onPressed: (){
                      Provider.of<TaskProvider>(context,listen: false).removeTask(task.id);
                      Navigator.pop(context);

                    }, icon: Icon(FlutterRemix.delete_bin_2_line,color: Colors.black,), label: Text('Delete',style: GoogleFonts.montserrat(fontWeight: FontWeight.w800,fontSize: 20.0,color: Colors.black),)),
                  )

                ],
              ),
            );
          });
        } ,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(task.data['completed']?FlutterRemix.checkbox_circle_line:FlutterRemix.checkbox_blank_circle_line,color: Colors.black,),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(child: Text(task.data['task'],style:GoogleFonts.montserrat(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.black),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(child: Text(task.data['description'],style:GoogleFonts.montserrat(fontSize: 18.0,fontWeight: FontWeight.w600,color: Colors.black54),)),
                  ),
                ],
              ),
            ),

          ]
        ),
      ),
    );
  }
}


class TaskCreator extends StatefulWidget {
  const TaskCreator({Key? key, required this.isUpdate,this.index,this.task}) : super(key: key);
  final bool isUpdate;
  final int? index;
  final DocumentSnapshot? task;


  @override
  _TaskCreatorState createState() => _TaskCreatorState();
}

class _TaskCreatorState extends State<TaskCreator> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isUpdate){
      taskController.text = widget.task!.data['task'];
      descriptionController.text = widget.task!.data['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(onPressed:(){
       if(widget.isUpdate){
         DocumentSnapshot snap = widget.task!;
         snap.data['task']= taskController.text;
         snap.data['description'] = descriptionController.text;
         if(taskController.text.isNotEmpty){
           Provider.of<TaskProvider>(context,listen: false).updateTask(snap,widget.index!);
         }


       }
       else{
         if(taskController.text.isNotEmpty){
           Provider.of<TaskProvider>(context,listen: false).addTask(taskController.text, descriptionController.text.isEmpty?'':descriptionController.text);

         }




       }
       Navigator.pop(context);


      },child: Icon(FlutterRemix.check_line),foregroundColor: Colors.black,backgroundColor: Colors.white,elevation: 10.0,),
      body: Padding(
        padding: const EdgeInsets.only(top:25.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: TextField(
                    controller: taskController,
                    cursorColor: Colors.black,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w800,fontSize: 20.0,color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Task',
                      contentPadding: EdgeInsets.zero,
                      hintStyle: GoogleFonts.montserrat(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: TextField(
                    controller: descriptionController,
                    cursorColor: Colors.black,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w800,fontSize: 18.0,color: Colors.black54),
                    decoration: InputDecoration(
                      hintText: 'Description',
                      contentPadding: EdgeInsets.zero,
                      hintStyle: GoogleFonts.montserrat(fontSize: 18.0,fontWeight: FontWeight.w800,color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
