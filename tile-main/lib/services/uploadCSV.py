import firebase_admin
import google.cloud
from firebase_admin import credentials, firestore
import csv

cred = credentials.Certificate("./dura-tiles-firebase-adminsdk-u2d4k-7fe6f7ebe2.json")
app = firebase_admin.initialize_app(cred)

store = firestore.client()
doc_ref = store.collection(u'TileInformation')

with open("./tileInfoSheet.csv", encoding="ISO-8859-1") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            pass
        else:          
            imageUrl = "gs://dura-tiles.appspot.com/" + row[1] + ".jpg"  #gs://dura-tiles.appspot.com/2_1933.255.jpg
            relevantLinks = [row[6].splitlines()[1].strip(), row[6].splitlines()[4].strip()]
            discoveryDate = row[0][:row[0].index(".")]
            photoId = row[1] + ".jpg"
            
            doc_ref.add({
                u'photoId': photoId, #good
                u'context': row[4], #good
                u'date': row[3], #good
                u'imageUrl': imageUrl, #good
                u'relevantLinks': relevantLinks,  #good
                u'subject': row[2], #good
                u'translation': row[5], #good
                u'discoveryDate': discoveryDate, #good
            })
            
        line_count+=1