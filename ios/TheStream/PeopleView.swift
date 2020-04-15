import SwiftUI
import GetStream

struct PeopleView: View {
    @State var users: [String] = []
    @State var showFollowedAlert: Bool = false
    @State var tag: Int? = nil
    @EnvironmentObject var account: Account
    
    var body: some View {
        List {
            ForEach(users.indices, id: \.self) { i in
                HStack() {
                    Text(self.users[i])
                    NavigationLink(destination: Text("Hello, \(self.users[i])").navigationBarTitle("Chat"), tag: i, selection: self.$tag) {
                        Spacer()
                    }
                    Image(systemName: "plus.circle").onTapGesture {
                        self.account.follow(self.users[i]) {
                            self.showFollowedAlert = true
                        }
                    }
                    Image(systemName: "message").onTapGesture {
                        self.tag = i
                    }

                }
            }
        }
        .onAppear(perform: fetch)
        .alert(isPresented: $showFollowedAlert) {
            Alert(title: Text("Followed"))
        }
        
    }
    
    private func fetch() {
        account.fetchUsers { users in
            self.users = users.filter { $0 != self.account.user! }
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView(users: ["bob", "sara"])
    }
}
