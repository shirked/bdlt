// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {
    
    // --- The Task Blueprint ---
    struct Task {
        string content;
        bool isCompleted;
    }

    // --- The Isolated Storage ---
    // 'private' means no automatic read buttons are created.
    // Maps a user's address to their personal list of Tasks.
    mapping(address => Task[]) private userTasks;

    // --- 1. Add a Task ---
    function addTask(string memory _content) public {
        // Creates a new task (not completed by default) and pushes it to the caller's list
        userTasks[msg.sender].push(Task(_content, false));
    }

    // --- 2. Update a Task ---
    function updateTask(uint _taskIndex, string memory _newContent) public {
        // Make sure the task actually exists in their list first
        require(_taskIndex < userTasks[msg.sender].length, "Error: Task does not exist.");
        
        // Update the text
        userTasks[msg.sender][_taskIndex].content = _newContent;
    }

    // --- 3. Mark as Completed ---
    function markCompleted(uint _taskIndex) public {
        require(_taskIndex < userTasks[msg.sender].length, "Error: Task does not exist.");
        
        // Flip the status to true
        userTasks[msg.sender][_taskIndex].isCompleted = true;
    }

    // --- 4. Read My Tasks (The Security Gate) ---
    // Because this strictly returns userTasks[msg.sender], it is impossible 
    // for anyone to fetch another person's list through this function.
    function getMyTasks() public view returns (Task[] memory) {
        return userTasks[msg.sender];
    }
}