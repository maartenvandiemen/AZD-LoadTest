from locust import HttpUser, task, between
import json

class TodoItemsApiUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def create_and_get_todo_item(self):
        # Define the new Todo item
        new_todo = {
            "name": "Sample Todo",
            "isComplete": False
        }

        # Perform the POST request to create a new Todo item
        response = self.client.post("/todoitems", json=new_todo)
        if response.status_code == 201:
            created_todo = response.json()
            todo_id = created_todo["id"]

            # Perform the GET request to retrieve the created Todo item
            get_response = self.client.get(f"/todoitems/{todo_id}")
            if get_response.status_code == 200:
                retrieved_todo = get_response.json()
                assert retrieved_todo["name"] == new_todo["name"]
                assert retrieved_todo["isComplete"] == new_todo["isComplete"]

                # Define the updated Todo item
                updated_todo = {
                    "name": "Updated Sample Todo",
                    "isComplete": True
                }

                # Perform the PUT request to update the Todo item
                put_response = self.client.put(f"/todoitems/{todo_id}", json=updated_todo)
                if put_response.status_code == 204:
                    # Perform the GET request to retrieve the updated Todo item
                    get_updated_response = self.client.get(f"/todoitems/{todo_id}")
                    if get_updated_response.status_code == 200:
                        updated_retrieved_todo = get_updated_response.json()
                        assert updated_retrieved_todo["name"] == updated_todo["name"]
                        assert updated_retrieved_todo["isComplete"] == updated_todo["isComplete"]