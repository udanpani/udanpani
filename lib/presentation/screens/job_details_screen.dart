import 'package:flutter/material.dart';
import 'package:udanpani/core/colors.dart';

class JobDetailsScreen extends StatefulWidget {
  JobDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  // Job job;
  late int index;

  Widget _details(/*Job job*/) {
    return Column(
      children: [
        Container(
          color: mobileSearchColor,
          height: 250,
          child: const Image(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1558904541-efa843a96f01?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1632&q=80"),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Lorem Ipsum Dolor Sit Amet $index",
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text("2h"),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque nec congue velit. Vestibulum sit amet euismod nisi. Proin dapibus sagittis molestie. Aenean placerat ante massa, ut iaculis neque mollis vel. Curabitur finibus sagittis porttitor. Nam rhoncus posuere enim in suscipit. Nam non euismod felis. Cras ultrices risus dolor, vitae aliquet massa dictum at. In et lacus rutrum diam placerat auctor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis tincidunt, leo a imperdiet lacinia, dolor est malesuada quam, vel lacinia lectus dui quis nulla. Vivamus a sollicitudin mauris. ",
              ),
              const SizedBox(height: 20),
              const Text("map goes here"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    index = (ModalRoute.of(context)?.settings.arguments ?? 0) as int;
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details"),
        backgroundColor: primaryColor.withOpacity(0.1),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _details(),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Accept",
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
