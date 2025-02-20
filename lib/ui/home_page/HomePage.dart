import 'package:birincisayim/features/product/data/repositories/GetProducts.dart';
import 'package:birincisayim/commons/ServerUrlHelper.dart';
import 'package:birincisayim/features/product/data/services/product_service.dart';
import 'package:birincisayim/features/project/data/services/project_service.dart';
import 'package:birincisayim/features/counter/domain/usecases/CountService.dart';
import 'package:birincisayim/features/line/presentation/pages/LinesPage.dart';
import 'package:birincisayim/features/project/data/repositories/GetProjects.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:birincisayim/features/counter/presentation/pages/CountListPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController ipAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Center(
          child: Text(
            "Sayim",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Ip adresi yazin"),
                        content: SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              TextFormField(controller: ipAddressController),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                ServerUrlHelper.setUrl(
                                    ipAddressController.text);
                                Navigator.pop(context);
                              },
                              child: const Text("Kaydet"))
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.private_connectivity_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: ProjectService.listProject(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final project = snapshot.data![index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => CountListPage(
                                    project: project,
                                  ),
                                ),
                              );
                            },
                            leading: const Icon(Icons.document_scanner),
                            title: Text(project.description),
                            subtitle: Text(
                                "${project.id} project - ${project.isYeri} isyeri - ${project.anbar} anbari"),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return const Text("data");
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          try {
            var projects = await GetProjectsFromApi.getAllProjects();
            var products = await GetProductsFromApi.getAllProducts();
            await ProjectService.clear();
            await ProjectService.insertAll(projects);

            await ProductService.clear();
            await ProductService.insertAll(products).then((e) {
              var snackBar =
                  const SnackBar(content: Text("Malzemeler basariyla alindi"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
            setState(() {});
          } on DioException catch (e) {
            if (e.type == DioExceptionType.connectionError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Sunucu ile baglanti kurulamadi")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Network sorunu : ${e.message}")));
            }
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        child: const Icon(
          Icons.update,
          color: Colors.white,
        ),
      ),
    );
  }
}
