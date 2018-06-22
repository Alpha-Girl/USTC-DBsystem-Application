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

typedef struct {	//申请锁的申请结构体
	int transID;	//申请的事务
	int type;		//申请的锁的种类
} ObjTrans;

typedef struct {//数据
	list<int> slist;			//持有该数据S锁的事务列表
	int xlockID = -1;			//若有事务持有X锁，则记录该事务ID，否则为-1
	queue<ObjTrans> lockqueue;	//申请锁的队列
} Object, *PObj;

struct TransObj {		//持有锁的结构体
	int objname;		//持有的锁的对象
	int type;			//持有的锁的种类
};

typedef struct {//事务
	list<TransObj> objList = {};	//事务所持有的锁的列表
} Trans, *PTrans;

vector<PTrans> tTable(256, nullptr);	//事务列表
Object oTable[26];						//数据信息列表

bool removeFromQ(queue<ObjTrans> &lockqueue, int id) {//将对锁的申请从申请队列中移除，并返回移除是否成功
	queue<ObjTrans> backup;
	bool tag = false;
	while(!lockqueue.empty()) {
		ObjTrans &tmp = lockqueue.front();
		lockqueue.pop();
		backup.push(tmp);
	}
	while(!backup.empty()) {
		ObjTrans *tmp = &backup.front();
		backup.pop();
		if (tmp->transID != id) {
			lockqueue.push(*tmp);
		}
		else {
			tag = true;
		}
	}
	return tag;
}

void printList(int ID) {//打印事务的相关信息
	PTrans atrans = tTable[ID];
	string type[2] = {"SLOCK", "XLOCK"};
	cout << "Transaction " << ID << ": " << endl;
	for (auto lock : atrans->objList) {
		cout << ID << " " << type[lock.type] << " " << (char)(lock.objname + 'A') << endl;
	}
	return;
}

void printObj(int name) {//打印数据的相关信息
	int n = (int) (name - 'A');
	Object *aobj = &oTable[n];
	string type[2] = {"SLOCK", "XLOCK"};
	if (aobj->xlockID == -1) {
		cout << "SList: ";
		for (auto s : aobj->slist) {
			cout << s << " ";
		}
		cout << endl;
		cout << "Queue: ";
		queue<ObjTrans> backup;
		bool tag = false;
		while(!aobj->lockqueue.empty()) {
			ObjTrans &tmp = aobj->lockqueue.front();
			cout << tmp.transID << "(" << type[tmp.type] << ") ";
			aobj->lockqueue.pop();
			backup.push(tmp);
		}
		while(!backup.empty()) {
			ObjTrans *tmp = &backup.front();
			backup.pop();
			aobj->lockqueue.push(*tmp);
		}
		cout << endl;
	}
	else {
		cout << "XLOCK: " << aobj->xlockID << endl;
		cout << "Queue: ";
		queue<ObjTrans> backup;
		bool tag = false;
		while(!aobj->lockqueue.empty()) {
			ObjTrans &tmp = aobj->lockqueue.front();
			cout << tmp.transID << "(" << type[tmp.type] << ") ";
			aobj->lockqueue.pop();
			backup.push(tmp);
		}
		while(!backup.empty()) {
			ObjTrans *tmp = &backup.front();
			backup.pop();
			aobj->lockqueue.push(*tmp);
		}
		cout << endl;
	}
}

void startTrans(int ID) {//开始一个事务
	if (tTable[ID] != nullptr) {
		cout << "Transaction" << ID << " already started!" << endl;
		return;
	}
	PTrans atrans = new Trans;
	tTable[ID] = atrans;
	cout << "Transaction " << ID << " started" << endl;
	return;
}

void sLockTrans(int ID, char name) {//给事务ID申请S锁
	if (tTable[ID] == nullptr) {
		cout << "Transaction" << ID << " hasn't started yet!" << endl;
		return;
	}
	int n = (int) (name - 'A');
	Object *aobj = &oTable[n];
	PTrans atrans = tTable[ID];
	if (aobj->xlockID == -1) {//无XLOCK
		aobj->slist.push_back(ID);	//在S锁列表中添加事务ID
		TransObj* ato = new TransObj;
		ato->objname = n;
		ato->type = SLOCK;
		atrans->objList.push_back(*ato);
		cout << "Lock granted" << endl;
	}
	else {//有X锁
		ObjTrans* aot = new ObjTrans;
		aot->transID = ID;
		aot->type = SLOCK;
		aobj->lockqueue.push(*aot);	//在申请队列中添加事务ID
		cout << "Waiting for lock (X-lock held by: " << aobj->xlockID << ")" << endl;
	}
}

void xLockTrans(int ID, char name) {//给事务申请X锁
	if (tTable[ID] == nullptr) {
		cout << "Transaction" << ID << " hasn't started yet!" << endl;
		return;
	}
	int n = (int) (name - 'A');
	Object *aobj = &oTable[n];
	PTrans atrans = tTable[ID];
	if (aobj->xlockID == -1 && aobj->slist.empty()) {//无XLOCK和SLOCK
		aobj->xlockID = ID;	//将X锁ID置为事务ID
		TransObj* ato = new TransObj;
		ato->objname = n;
		ato->type = XLOCK;
		atrans->objList.push_back(*ato);	//在事务的持有锁列表中添加信息
		cout << "Lock granted" << endl;
	}
	else if (aobj->xlockID == -1 && aobj->slist.size() == 1 && aobj->slist.front() == ID) {//无XLOCK，更新SLOCK为XLOCK，且没有其他S锁
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
	else {	//无法添加锁
		ObjTrans* aot = new ObjTrans;
		aot->transID = ID;
		aot->type = XLOCK;
		aobj->lockqueue.push(*aot);		//在申请队列中添加表项
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

void unlockTrans(int ID, char name) {//释放锁
	if (tTable[ID] == nullptr) {
		cout << "Transaction " << ID << " hasn't started yet!" << endl;
		return;
	}
	int n = (int) (name - 'A');
	Object *aobj = &oTable[n];
	PTrans atrans = tTable[ID];
	if (atrans->objList.empty()) {
		cout << "Transaction " << ID << " has no lock on " << name << endl;
		return;
	}
	//在事务的持有锁列表中寻找对应表项
	TransObj *ato = &atrans->objList.front();
	for (auto tmpto: atrans->objList) {
		if (tmpto.objname == n) {
			ato = &tmpto;
			break;
		}
	}
	if (ato->objname != n) {
		cout << "Transaction " << ID << " has no lock on " << name << endl;
		return;
	}
	
	if (ato->type == SLOCK) {//该锁为S锁
		bool inslist = false;
		//检查该事务是否真的获得了锁
		for (auto d : aobj->slist) {
			if (d == ID) {
				inslist = true;
				break;
			}
		}
		if (inslist) {//确实获得了锁
			cout << "S-lock on " << name << " released" << endl;
			aobj->slist.remove(ID);	//在数据的S锁列表中除去相应表项
			for (auto iter = atrans->objList.begin(); iter != atrans->objList.end(); iter ++) {	//在事务的持有锁列表中除去相应表项
				if (iter->objname == n) {
					atrans->objList.erase(iter);
					break;
				}
			}
			if (aobj->slist.empty() && !aobj->lockqueue.empty()) {//SLOCK已为空且有申请XLOCK的
				ObjTrans *aobjTrans = &aobj->lockqueue.front();		//申请队列的队头
				aobj->lockqueue.pop();
				aobj->xlockID = aobjTrans->transID;
				PTrans btrans = tTable[aobjTrans->transID];		//申请队头的事务ID
				/*TransObj *newto = new TransObj;
				newto->objname = n;
				newto->type = XLOCK;
				btrans->objList.push_back(*newto);*/
				//寻找该申请锁的事务是不是原本持有S锁
				TransObj *bto = &btrans->objList.front();
				for (auto tmpto: btrans->objList) {
					if (tmpto.objname == n) {
						bto = &tmpto;
						break;
					}
				}
				if (!btrans->objList.empty() && bto->objname == n) {//队列中的是要更新原有的S锁
					bto->type = XLOCK;
				}
				else {	//申请新的锁
					TransObj *newto = new TransObj;
					newto->objname = n;
					newto->type = XLOCK;
					btrans->objList.push_back(*newto);
				}
				cout << "X-lock granted to " << aobjTrans->transID << endl;
			}
		}
		else {//尚未获得锁，仍在等待中
			if (removeFromQ(aobj->lockqueue, ID)) {//将它从申请队列中移除
				cout << "S-lock on " << name << " released" << endl;
			}
			else {
				cout << "Transaction " << ID << " has no S-lock on " << name << endl;
			}
		}
	}
	else if (ato->type == XLOCK) {//该锁为X锁
		if (aobj->xlockID != ID) {
			if (removeFromQ(aobj->lockqueue, ID)) {	//X锁仍在等待中，将它从申请队列中移除
				cout << "X-lock on " << name << " released" << endl;
			}
			else {
				cout << "Transaction " << ID << " has no X-lock on " << name << endl;
			}
		}
		else {//X锁之前已获得
			cout << "X-lock on " << name << " released" << endl;
			aobj->xlockID = -1;
			for (auto iter = atrans->objList.begin(); iter != atrans->objList.end(); iter ++) {	//在事务的持有锁列表中除去相应表项
				if (iter->objname == n) {
					atrans->objList.erase(iter);
					break;
				}
			}
			if (aobj->lockqueue.empty()) {//没有申请锁的事务
				return;
			}
			ObjTrans *q = &aobj->lockqueue.front();
			if (q->type == XLOCK) {//队头为请求XLOCK的事务
				ObjTrans *aobjTrans = &aobj->lockqueue.front();		//申请队列的队头
				aobj->lockqueue.pop();
				aobj->xlockID = aobjTrans->transID;
				PTrans btrans = tTable[aobjTrans->transID];		//申请队头的事务ID
				TransObj *bto = &btrans->objList.front();
				for (auto tmpto: btrans->objList) {
					if (tmpto.objname == n) {
						bto = &tmpto;
						break;
					}
				}
				cout << "here2 " << aobjTrans->transID << bto->objname << endl;
				if (!btrans->objList.empty() && bto->objname == n) {//队列中的是要更新锁
					bto->type = XLOCK;
				}
				else {	//申请新的锁
					TransObj *newto = new TransObj;
					newto->objname = n;
					newto->type = XLOCK;
					btrans->objList.push_back(*newto);
				}
				cout << "X-lock granted to " << aobjTrans->transID << endl;
			}
			else if (q->type == SLOCK) {//队头为请求SLOCK的事务
				queue<ObjTrans> backup;
				while(!aobj->lockqueue.empty()) {	//将队列中表项移动到BACKUP中
					ObjTrans &tmp = aobj->lockqueue.front();
					aobj->lockqueue.pop();
					backup.push(tmp);
				}
				while(!backup.empty()) {	//逐个检查申请的是S锁还是X锁
					ObjTrans *tmp = &backup.front();
					backup.pop();
					if (tmp->type == XLOCK) {	//若申请的是X锁则放回原队列
						aobj->lockqueue.push(*tmp);
					}
					else {	//若申请的是S锁，则可以直接全部赋予锁
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
}

void endTrans(int ID) {	//结束事务
	if (tTable[ID] == nullptr) {
		cout << "Transaction" << ID << " hasn't started yet!" << endl;
		return;
	}
	cout << "Transaction " << ID << " ended" << endl;
	PTrans atrans = tTable[ID];
	while(!atrans->objList.empty()) {	//释放所持有的全部锁
		auto lock = atrans->objList.front();
		unlockTrans(ID, (char)(lock.objname + 'A'));
	}
	for (int i = 0; i < 26; i ++) {		//在所有数据的申请队列中检查是否有该事务的排队表项，有就移除
		removeFromQ(oTable[i].lockqueue, ID);
	}
	delete tTable[ID];
	tTable[ID] = nullptr;
	return;
}

void printHelp(){//输出帮助信息
	cout << "Usage: <request type> <transaction ID> [object]" << endl;
	cout << "These are all the request types used in various situations." << endl;
	cout << "(All the commads are case insensitive)" << endl;
	cout << "	Start <trans ID>			start a transaction" << endl;
	cout << "	End <trans ID>				abort or commit a transaction" << endl;
	cout << "	XLock <trans ID> <object>	request for an X lock" << endl;
	cout << "	SLock <trans ID> <object>	request for an S lock" << endl;
	cout << "	Unlock <trans ID> <object>	release a lock" << endl;
	cout << "	Print <trans ID>			print information about this transaction" << endl;
	cout << "	Info <object>				print information about this object" << endl;
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
		else if (s == "PRINT") {
			cin >> ID;
			printList(ID);
		}
		else if (s == "INFO") {
			cin >> name;
			printObj(name);
		}
		else {
			printHelp();
		}
	}
	return 0;
}