import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:smart_contract/contracts/contracts.dart';
import 'package:smart_contract/pinata/metadata.dart';
import 'package:smart_contract/pinata/pinata.dart';
import 'package:smart_contract/views/webview_screen.dart';

class PickerHomeApp extends StatelessWidget {
  const PickerHomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'NFT mint',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String cidImage = "";
  String cidImageMetadata = "";
  bool isLoading = false;

  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final PickedFile? pickedImage =
    await _picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImageToPinata() async {
    final pinata = Pinata();
    Response<dynamic>? response;
    if (_image != null){
      setState(() {
        isLoading = true;
      });
      // upload image
      response = await pinata.pinFileToIPFS(file: _image!);
    }
    if (response != null  && response.statusCode == 200) {
      String? fileName = _image?.path.split('/').last;
      final pinataOptions = PinataOptions();
      final pinataMetadata = PinataMetadata()
      ..name = "${(fileName as String).replaceFirst(".jpg", "_")}Metadata";

      String imageCid = response.data["IpfsHash"];
      cidImage = imageCid ?? "";

      Metadata metadata = Metadata()
        ..name = "NFT Name"
        ..image = "https://gateway.pinata.cloud/ipfs/$imageCid"
        ..externalUrl = "NFTExternalImage"
        ..description = "nftDescription";

      final jsonBody = {
        "pinataOptions" : pinataOptions.toJson(),
        "pinataMetadata" : pinataMetadata.toJson(),
        "pinataContent" : metadata
      };

      // upload metadata
      final metadataResponse = await pinata.pinJSONToIPFS(jsonBody);
      if (metadataResponse != null  && metadataResponse.statusCode == 200) {
          cidImageMetadata = metadataResponse.data["IpfsHash"];
          setState(() {isLoading = false;});
          showSnackBarWithMessage("Metadata uploaded successfully!, Cid:$cidImageMetadata");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload NFT Image'),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF283593), Colors.white70],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  if (!isLoading) {
                    return buildOptionsColumn();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              ),
            ),
          ),
        ));
  }

  Widget buildOptionsColumn() {
    return Column(children: [
      Center(
        child: ElevatedButton(
          child: const Text('Smart Contract deployment'),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => WebViewExample())
            );
          },
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: ElevatedButton(
          child: const Text('Select An Image'),
          onPressed: _openImagePicker,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 200,
        color: Colors.transparent,
        child: _image != null
            ? Image.file(_image!, fit: BoxFit.cover)
            : const Text('Please select an image'),
      ),
      const SizedBox(height: 20),
      Center(
        child: ElevatedButton(
          child: const Text('Upload to IPFS'),
          onPressed: _uploadImageToPinata,
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: ElevatedButton(
          child: const Text('Mint NFT'),
          onPressed: () {
            if (cidImageMetadata.isNotEmpty) {
              setState(() {isLoading = true;});
              NftContract().mintWithCid(cidImageMetadata);
              setState(() {isLoading = false;});
            }
          },
        ),
      ),
    ]);
  }

    showSnackBarWithMessage (String message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message)
          ],
        ),
      ));
    }
}