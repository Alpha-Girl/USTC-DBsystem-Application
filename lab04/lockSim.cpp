#include <iostream>
#include <string>
#include <vector>
#include <list>
#include <queue>

using std::cin;
using std::cout;
using std::endl;
using std::noskipws;
using std::string;
using std::vector;
using std::list;
using std::queue;

#define XLOCK 1
#define SLOCK 0

typedef struct {
	int transID;
	int type;
} ObjTrans;

typedef struct {
	list<int> slist;
	int xlockID = -1;
	queue<ObjTrans> lockqueue;
} Object, *PObj;

typedef struct {
	int objname;
	int type;
} TransObj;

typedef struct {
	list<TransObj> objList = {};
} Trans, *PTrans;

vector<PTrans> tTable(256, nullptr);
Object oTable[26];

void startTrans(int ID) {
	if (tTable[ID] != nullptr) {
		cout << "Transaction" << ID << " already started!" << endl;
		return;
	}
	PTrans atrans = new Trans;
	tTable[ID] = atrans;
	cout << "Transaction " << ID << " started" << endl;
	return;
}

void sLockTrans(int ID, char name) {
	if (tTable[ID] == nullptr) {
		cout << "Transaction" << ID << " hasn't started yet!" << endl;
		return;
	}
	int n = (int) (name - 'A');
	Object *aobj = &oTable[n];
	PTrans atrans = tTable[ID];
	if (aobj->xlockID == -1) {//无XLOCK
		aobj->slist.push_back(ID);	//添加事务ID
		TransObj* ato = new TransObj;
		ato->objname = n;
		ato->type = SLOCK;
		atrans->objList.push_back(*ato);
		cout << "Lock granted" << endl;
	}
	else {
		ObjTrans* aot = new ObjTrans;
		aot->transID = ID;
		aot->type = SLOCK;
		aobj->lockqueue.push(*aot);
		cout << "Waiting for lock (X-lock held by: " << aobj->xlockID << ")" << endl;
	}
}

void xLockTrans(int ID, char name) {
	if (tTable[ID] == nullptr) {
		cout << "Transaction" << ID << " hasn't started yet!" << endl;
		return;
	}
	int n = (int) (name - 'A');
	Object *aobj = &oTable[n];
	PTrans atrans = tTable[ID];
	if (aobj->xlockID == -1 && aobj->slist.empty()) {//无XLOCK和SLOCK
		aobj->xlockID = ID;	//添加事务ID
		TransObj* ato = new TransObj;
		ato->objname = n;
		ato->type = XLOCK;
		atrans->objList.push_back(*ato);
		cout << "Lock granted" << endl;
	}
	else if (aobj->xlockID == -1 && aobj->slist.size() == 1 && aobj->slist.front() == ID) {//无XLOCK，更新SLOCK为XLOCK
		aobj->slist.remove(ID);
		aobj->xlockID = ID;	//添加事务ID
		TransObj *ato = &atrans->objList.front();//更新事务持有的锁
		for (auto tmpto: atrans->objList) {
			if (tmpto.objname == n) {
				ato = &tmpto;
				break;
			}
		}
		ato->type = XLOCK;
		cout << "Upgrade to X-lock granted" << endl;
	}
	else {
		ObjTrans* aot = new ObjTrans;
		aot->transID = ID;
		aot->type = XLOCK;
		aobj->lockqueue.push(*aot);
		if (aobj->xlockID == -1) {
			cout << "Waiting for lock (S-lock held by: ";
			for (auto s : aobj->slist) {
				cout << s << " ";
			}
			cout << ")" << endl;
		}
		else {
			cout << "Waiting for lock (X-lock held by: " << aobj->xlockID << ")" << endl;
		}
	}
}

void unlockTrans(int ID, char name) {
	if (tTable[ID] == nullptr) {
		cout << "Transaction" << ID << " hasn't started yet!" << endl;
		return;
	}
	int n = (int) (name - 'A');
	Object *aobj = &oTable[n];
	PTrans atrans = tTable[ID];
	if (atrans->objList.empty()) {
		cout << "Transaction" << ID << " has no lock on " << name << endl;
	}
	TransObj *ato = &atrans->objList.front();
	for (auto tmpto: atrans->objList) {
		if (tmpto.objname == n) {
			ato = &tmpto;
			break;
		}
	}
	if (ato->objname != n) {
		cout << "Transaction " << ID << " has no lock on " << name << endl;
	}
	if (ato->type == SLOCK) {
		cout << "S-lock on " << name << " released" << endl;
		aobj->slist.remove(ID);
		if (aobj->slist.empty() && !aobj->lockqueue.empty()) {
			ObjTrans *aobjTrans = &aobj->lockqueue.front();
			aobj->lockqueue.pop();
			aobj->xlockID = aobjTrans->transID;
			PTrans btrans = tTable[aobjTrans->transID];
			TransObj *bto = &btrans->objList.front();
			for (auto tmpto: btrans->objList) {
				if (tmpto.objname == n) {
					bto = &tmpto;
					break;
				}
			}
			if (bto->objname == n) {//队列中的是要更新锁
				bto->type = XLOCK;
			}
			else {
				TransObj *newto = new TransObj;
				newto->objname = n;
				newto->type = XLOCK;
				btrans->objList.push_back(*newto);
			}
			cout << "X-lock granted to " << aobjTrans->transID << endl;
		}
	}
	else if (ato->type == XLOCK) {
		cout << "X-lock on " << name << " released" << endl;
		if (aobj->xlockID != ID) {
			cout << "Transaction " << ID << " has no X-lock on " << name << endl;
		}
		aobj->xlockID = -1;
		ObjTrans *q = &aobj->lockqueue.front();
		if (q->type == XLOCK) {
			ObjTrans *aobjTrans = &aobj->lockqueue.front();
			aobj->lockqueue.pop();
			aobj->xlockID = aobjTrans->transID;
			PTrans btrans = tTable[aobjTrans->transID];
			TransObj *bto = &btrans->objList.front();
			for (auto tmpto: btrans->objList) {
				if (tmpto.objname == n) {
					bto = &tmpto;
					break;
				}
			}
			if (bto->objname == n) {//队列中的是要更新锁
				bto->type = XLOCK;
			}
			else {
				TransObj *newto = new TransObj;
				newto->objname = n;
				newto->type = XLOCK;
				btrans->objList.push_back(*newto);
			}
			cout << "X-lock granted to " << aobjTrans->transID << endl;
		}
		else if (q->type == SLOCK) {
			queue<ObjTrans> backup;
			while(!aobj->lockqueue.empty()) {
				ObjTrans &tmp = aobj->lockqueue.front();
				aobj->lockqueue.pop();
				backup.push(tmp);
			}
			while(!backup.empty()) {
				ObjTrans *tmp = &backup.front();
				backup.pop();
				if (tmp->type == XLOCK) {
					aobj->lockqueue.push(*tmp);
				}
				else {
					aobj->slist.push_back(tmp->transID);
					TransObj *newobj = new TransObj;
					newobj->objname = n;
					newobj->type = SLOCK;
					tTable[tmp->transID]->objList.push_back(*newobj);
					cout << "S-lock granted to " << tmp->transID << endl;
					delete tmp;
				}
			}
		}
	}
}

void endTrans(int ID) {
	if (tTable[ID] == nullptr) {
		cout << "Transaction" << ID << " hasn't started yet!" << endl;
		return;
	}
	cout << "Transaction " << ID << " ended" << endl;
	PTrans atrans = tTable[ID];
	while(!atrans->objList.empty()) {
		auto lock = atrans->objList.front();
		atrans->objList.pop_front();
		unlockTrans(ID, (char)(lock.objname + 'A'));
	}
	delete tTable[ID];
	tTable[ID] = nullptr;
	return;
}

void printHelp(){
	cout << "Usage: <request type> <transaction ID> [object]" << endl;
	cout << "These are all the request types used in various situations." << endl;
	cout << "(All the commads are case insensitive)" << endl;
	cout << "	Start <trans ID>			start a transaction" << endl;
	cout << "	End <trans ID>				abort or commit a transaction" << endl;
	cout << "	XLock <tans ID> <object>	request for an X lock" << endl;
	cout << "	SLock <tans ID> <object>	request for an S lock" << endl;
	cout << "	Unlock <tans ID> <object>	release a lock" << endl;
	cout << "	Help						output help documents" << endl;
	cout << "	Quit						quit this program" << endl;
	cout << "Transaction ID is the ID of a transaction which ranges from 0 to 255. And object which is represented by a capital letter, is the database object to add a lock on" << endl;
}

string readline() {
	string s;
	cout << ">>> ";
	cin >> s;
	for (auto &c : s) {
		if (c >= 'a' && c <= 'z') {
			c += 'A' - 'a';
		}
	}
	return s;
}

int main(){
	string s;
	cout << "DataBase Lock Manager Simulator" << endl;
	while ((s = readline()) != "QUIT") {
		int ID;
		char name;
		if (s == "START") {//Start
			cin >> ID;
			cout << s << " " << ID << ": ";
			if (ID < 0 || ID > 255) {
				printHelp();
				continue;
			}
			startTrans(ID);
		}
		else if (s == "END") {//End
			cin >> ID ;
			cout << s << " " << ID << ": ";
			if (ID < 0 || ID > 255) {
				printHelp();
				continue;
			}
			endTrans(ID);
		}
		else if (s == "XLOCK") {//XLock
			cin >> ID >> name;
			cout << s << " " << ID << " " << name << ": ";
			if (ID < 0 || ID > 255 || name < 'A' || name > 'Z') {
				printHelp();
				continue;
			}
			xLockTrans(ID, name);
		}
		else if (s == "SLOCK") {//SLock
			cin >> ID >> name;
			cout << s << " " << ID << " " << name << ": ";
			if (ID < 0 || ID > 255 || name < 'A' || name > 'Z') {
				printHelp();
				continue;
			}
			sLockTrans(ID, name);
		}
		else if (s == "UNLOCK") {//Unlock
			cin >> ID >> name;
			cout << s << " " << ID << " " << name << ": ";
			if (ID < 0 || ID > 255 || name < 'A' || name > 'Z') {
				printHelp();
				continue;
			}
			unlockTrans(ID, name);
		}
		else {
			printHelp();
		}
	}
	return 0;
}