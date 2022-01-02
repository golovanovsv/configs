# http протокол
tshark -Y http.request -T fields -e http.file_data -e http.request.method port 18666

