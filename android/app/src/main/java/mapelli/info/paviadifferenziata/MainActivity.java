package mapelli.info.paviadifferenziata;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomSheetBehavior;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ListAdapter;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

import mapelli.info.paviadifferenziata.model.Waste;
import mapelli.info.paviadifferenziata.model.WasteAdapter;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = MainActivity.class.getSimpleName();
    private FloatingActionButton fab ;
    private View bottomSheet;
    Animation growAnimation ;
    Animation shrinkAnimation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        growAnimation = AnimationUtils.loadAnimation(this, R.anim.simple_grow);
        shrinkAnimation = AnimationUtils.loadAnimation(this, R.anim.simple_shrink);

        setupFab();
        //setupBottomSheet();
        initListView();


    }

    private void setupBottomSheet() {
        CoordinatorLayout coordinatorLayout = (CoordinatorLayout) findViewById(R.id.coordinator_layout);
        //bottomSheet = coordinatorLayout.findViewById(R.id.bottom_sheet);
        final BottomSheetBehavior behavior = BottomSheetBehavior.from(bottomSheet);
        behavior.setBottomSheetCallback(new BottomSheetBehavior.BottomSheetCallback() {
            @Override
            public void onStateChanged(@NonNull View bottomSheet, int newState) {
                switch (newState) {
                    case BottomSheetBehavior.STATE_COLLAPSED:

                        growAnimation.setAnimationListener(new Animation.AnimationListener() {
                            @Override
                            public void onAnimationStart(Animation animation) {

                            }

                            @Override
                            public void onAnimationEnd(Animation animation) {
                                fab.setVisibility(View.VISIBLE);
                            }

                            @Override
                            public void onAnimationRepeat(Animation animation) {

                            }
                        });
                        fab.startAnimation(growAnimation);
                        break;
                    case BottomSheetBehavior.STATE_EXPANDED:

                        shrinkAnimation.setAnimationListener(new Animation.AnimationListener() {
                            @Override
                            public void onAnimationStart(Animation animation) {

                            }

                            @Override
                            public void onAnimationEnd(Animation animation) {
                                fab.setVisibility(View.GONE);
                            }

                            @Override
                            public void onAnimationRepeat(Animation animation) {

                            }
                        });
                        fab.startAnimation(shrinkAnimation);
                        break;
                }
            }

            @Override
            public void onSlide(@NonNull View bottomSheet, float slideOffset) {
                // React to dragging events
                Log.e("onSlide", "onSlide");
            }
        });

        behavior.setPeekHeight(100);
    }

    private void setupFab() {
         fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d(TAG, "click!" );
            //BottomSheetBehavior.from(bottomSheet).setState(BottomSheetBehavior.STATE_EXPANDED);
            }
        });
    }

    private void initListView() {
        ListView list = (ListView) findViewById(R.id.listView);
        list.setAdapter(getListAdapter());
        list.setTextFilterEnabled(true);

    }

    private ListAdapter getListAdapter() {
        return new WasteAdapter(this, R.layout.waste_row, getWasteList().toArray(new
                Waste[0]));
    }

    private List<Waste> getWasteList() {
        ArrayList<Waste> wastes = new ArrayList<>();
        wastes.add(new Waste("a", Waste.Type.GENERIC));
        wastes.add(new Waste("b", Waste.Type.GENERIC));
        wastes.add(new Waste("c", Waste.Type.GENERIC));
        wastes.add(new Waste("d", Waste.Type.GENERIC));
        return wastes;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
