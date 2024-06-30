from concurrent import futures
import time 
import uuid

import grpc 
import library_pb2
import library_pb2_grpc

class LibraryService(library_pb2_grpc.LibraryServiceServicer):
    def __init__(self):
        self.books = {}  
        self._add_sample_books()

    def _add_sample_books(self):
        #dict for the books
        sample_books = [
            {"title": "To Kill a Mockingbird", "author": "Harper Lee"},
            {"title": "1984", "author": "George Orwell"},
            {"title": "Pride and Prejudice", "author": "Jane Austen"},
            {"title": "The Great Gatsby", "author": "F. Scott Fitzgerald"},
            {"title": "Moby Dick", "author": "Herman Melville"}
        ]
        for book_data in sample_books:
            book = library_pb2.Book(
                bid=str(uuid.uuid4()),
                title=book_data["title"],
                author=book_data["author"]
            )
            self.books[book.bid] = book

    def CreateBook(self, request, context):
        book = request.book
        book.bid = str(uuid.uuid4())  # Generate a unique ID
        self.books[book.bid] = book
        return library_pb2.CreateBookResponse(book=book)

    def GetBook(self, request, context):
        book = self.books.get(request.id)
        if not book:
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details("Book not found")
            return library_pb2.Book()
        return book

    def UpdateBook(self, request, context):
        if request.id not in self.books:
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details("Book not found")
            return library_pb2.Book()
        updated_book = request.book
        updated_book.bid = request.id  # Ensure the ID doesn't change
        self.books[request.id] = updated_book
        return updated_book

    def DeleteBook(self, request, context):
        if request.id not in self.books:
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details("Book not found")
            return library_pb2.DeleteResponse(success=False)
        del self.books[request.id]
        return library_pb2.DeleteResponse(success=True)

    def ListBooks(self,request, context):
        books_list = list(self.books.values())
        return library_pb2.ListBooksResponse(books=books_list)

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    library_pb2_grpc.add_LibraryServiceServicer_to_server(LibraryService(), server)
    server.add_insecure_port('localhost:50051')
    print("Starting server on port 50051...")
    server.start()
    try:
        while True:
            time.sleep(86400)  # Sleep for a day
    except KeyboardInterrupt:
        server.stop(0)
        print("Server stopped.")

if __name__ == '__main__':
    serve()