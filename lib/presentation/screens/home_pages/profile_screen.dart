import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/domain/models/review/review.dart';
import 'package:udanpani/domain/models/user_model/user.dart' as udanpani;
import 'package:udanpani/presentation/screens/auth_pages/login_screen.dart';
import 'package:udanpani/presentation/screens/auth_pages/signup_screen.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/widgets/loadingwidget.dart';
import 'package:udanpani/widgets/showSnackbar.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.uid}) : super(key: key);

  String? uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  udanpani.User? _user;
  bool _isLoading = true;
  bool _isReviewsLoading = true;
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  _getProfile() async {
    setState(() {
      _isLoading = true;
    });

    widget.uid = FirebaseAuth.instance.currentUser!.uid;

    udanpani.User user = await FirestoreMethods().getUser(widget.uid!);

    if (!mounted) return;
    setState(() {
      _user = user;
      _isLoading = false;
    });

    _getReviews();
  }

  _getReviews() async {
    if (!mounted)
      return setState(() {
        _isReviewsLoading = true;
      });

    var reviews = await FirestoreMethods().getReviews(_user!.reviews!);

    if (!mounted) return;
    setState(() {
      _isReviewsLoading = false;
      _reviews = reviews;
    });
  }

  _signout(context) async {
    String res = await AuthMethods().signoutUser();
    if (res != "success") {
      showSnackbar(context, res);

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  _buildStars(double stars,
      {MainAxisAlignment alignment = MainAxisAlignment.center}) {
    int i = 0;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        for (i = 0; i < stars; i++) Icon(Icons.star),
        for (; i < 5; i++) Icon(Icons.star_border_outlined, color: Colors.grey),
        const SizedBox(
          width: 5,
        ),
        Text("$stars / 5"),
      ],
    );
  }

  _buildReviews() {
    if (_reviews.length == 0) {
      return Text("No Reviews");
    }
    return ListView.builder(
        itemCount: _reviews.length,
        itemBuilder: (context, index) => ListTile(
              tileColor: Color.fromARGB(31, 206, 202, 202),
              isThreeLine: true,
              title: _buildStars(_reviews[index].rating,
                  alignment: MainAxisAlignment.start),
              subtitle: Text(_reviews[index].review +
                  "\n - ${_reviews[index].reviewerUname}"),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              _signout(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: _isLoading && _user == null
          ? LoadingWidget()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(_user!.profilePicture!),
                    backgroundColor: primaryColor,
                    radius: 60,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(_user!.username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(_user!.name),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Verification: " + _user!.verifications!),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildStars(_user!.rating!),
                  const SizedBox(
                    height: 30,
                  ),
                  Text("REVIEWS: "),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child:
                        _isReviewsLoading ? LoadingWidget() : _buildReviews(),
                  ),
                ],
              ),
            ),
    );
  }
}
