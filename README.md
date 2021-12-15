# teacher_student_firebase
#Details
An app which lets teacher create an account and create a list of students
FRONTEND
1. Login, Signup as a teacher along with email verification links
2. Create a list of students that can only be modified by the teacher themselves
3. Secure firestore rules ensure that the teacher is the only one who can read the student list of his account and no one else
4. Real time updating list of students even when it is edited through CLI or Browser console
5. Use of provider and firebaseAuth's "onAuthStateChange" to provide persistent login and logout functionality
    without actually storing anything on the local device.


BACKEND
6. Well designed collection in firestore where each teacher is a doc and student lists is another collection inside the teacher's doc
    This ensures that if we have thousands of teacher docs and each of them have thousands of student we are still going to get very fast
    read and write actions performed on the student list as they reside soley inside the teacher docs instead of being stored in one single
    table hence shrinks the load by quite a significant amount if compared to storing all student in one single table
7. Rules of firestore setup in a way that only allows a teacher to be able to edit his/her student list and authenticated
    users will have the permission to create new docs of teacher
